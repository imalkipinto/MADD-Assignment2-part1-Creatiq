import Foundation
import SwiftUI
import SwiftData
import AVFoundation

@MainActor
final class MoodboardViewModel: ObservableObject {
    @Published var items: [MoodboardItem] = []
    @Published var trendingMessage: String?
    @Published var currentlyPlayingID: UUID?
    @Published var isLoading: Bool = false

    private let context: ModelContext
    private var audioPlayer: AVAudioPlayer?

    init(context: ModelContext) {
        self.context = context
        loadItems()
    }

    func loadItems() {
        let descriptor = FetchDescriptor<MoodboardItem>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        if let result = try? context.fetch(descriptor) {
            items = result
        }
    }

    func addItem(image: UIImage, note: String, audioChoice: String?) {
        isLoading = true
        Task {
            let data = image.jpegData(compressionQuality: 0.85)
            let analysis = await MoodboardAnalyzer.analyze(image: image, note: note)

            await MainActor.run {
                let item = MoodboardItem(
                    imageData: data,
                    note: note,
                    createdAt: .now,
                    tag: analysis.tag,
                    themes: analysis.themes,
                    dominantColors: analysis.colors,
                    audioURL: audioChoice
                )
                context.insert(item)
                try? context.save()
                loadItems()
                showTrendingPopup(for: item)
                isLoading = false
            }
        }
    }

    func updateItem(_ item: MoodboardItem, note: String, audioChoice: String?) {
        item.note = note
        item.audioURL = audioChoice

        Task {
            if let data = item.imageData, let image = UIImage(data: data) {
                let analysis = await MoodboardAnalyzer.analyze(image: image, note: note)
                await MainActor.run {
                    item.tag = analysis.tag
                    item.themes = analysis.themes
                    item.dominantColors = analysis.colors
                    try? context.save()
                    loadItems()
                }
            } else {
                try? context.save()
                loadItems()
            }
        }
    }

    func deleteItem(_ item: MoodboardItem) {
        context.delete(item)
        try? context.save()
        loadItems()
    }

    func playAudio(for item: MoodboardItem) {
        guard let audioName = item.audioURL, !audioName.isEmpty else {
            stopAudio()
            return
        }

        if currentlyPlayingID == item.id {
            stopAudio()
            return
        }

        guard let url = Bundle.main.url(forResource: audioName, withExtension: nil) else {
            stopAudio()
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            currentlyPlayingID = item.id
        } catch {
            stopAudio()
        }
    }

    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        currentlyPlayingID = nil
    }

    private func showTrendingPopup(for item: MoodboardItem) {
        let emoji = item.themes.contains(where: { $0.lowercased().contains("night") || $0.lowercased().contains("dark") }) ? "🌙" : "✨"
        trendingMessage = "Trending: \(item.tag.isEmpty ? "New inspo" : item.tag) \(emoji)"

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            if trendingMessage == nil { return }
            trendingMessage = nil
        }
    }
}

struct MoodboardAnalysisResult {
    let tag: String
    let themes: [String]
    let colors: [String]
}

enum MoodboardAnalyzer {
    static func analyze(image: UIImage, note: String) async -> MoodboardAnalysisResult {
        // Very lightweight, deterministic "ML-style" analysis.
        let colors = SimplePaletteExtractor.extractHexColors(from: image, maxColors: 5)
        let lowerNote = note.lowercased()

        var themes: [String] = []
        if lowerNote.contains("night") || lowerNote.contains("city") {
            themes.append("night vibes")
        }
        if lowerNote.contains("beige") || lowerNote.contains("neutral") {
            themes.append("warm neutrals")
        }
        if lowerNote.contains("pastel") {
            themes.append("soft pastel")
        }
        if lowerNote.contains("studio") || lowerNote.contains("set") {
            themes.append("studio shoot")
        }
        if themes.isEmpty {
            themes.append("aesthetic")
        }

        let tag: String
        if lowerNote.contains("cozy") {
            tag = "Cozy inspo ✨"
        } else if lowerNote.contains("city") {
            tag = "City lights ✨"
        } else if lowerNote.contains("outfit") || lowerNote.contains("look") {
            tag = "Outfit mood ✨"
        } else {
            tag = "Creative spark ✨"
        }

        return MoodboardAnalysisResult(tag: tag, themes: Array(Set(themes)), colors: colors)
    }
}

enum SimplePaletteExtractor {
    static func extractHexColors(from image: UIImage, maxColors: Int) -> [String] {
        // Very simple downsampling-based palette. This is intentionally lightweight
        // for the assignment and mimics a color-extraction model.
        guard let cgImage = image.cgImage else { return [] }

        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContext(size)
        UIImage(cgImage: cgImage).draw(in: CGRect(origin: .zero, size: size))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let smallImage = resized, let smallCG = smallImage.cgImage else { return [] }

        let width = smallCG.width
        let height = smallCG.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var rawData = [UInt8](repeating: 0, count: Int(height * width * 4))

        guard let context = CGContext(
            data: &rawData,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return []
        }

        context.draw(smallCG, in: CGRect(x: 0, y: 0, width: width, height: height))

        var buckets: [UInt32: Int] = [:]
        for x in 0..<width {
            for y in 0..<height {
                let byteIndex = (bytesPerRow * y) + x * bytesPerPixel
                let r = rawData[byteIndex]
                let g = rawData[byteIndex + 1]
                let b = rawData[byteIndex + 2]

                // Quantize to reduce similar colors
                let qr = UInt32(r / 32) * 32
                let qg = UInt32(g / 32) * 32
                let qb = UInt32(b / 32) * 32
                let key = (qr << 16) | (qg << 8) | qb
                buckets[key, default: 0] += 1
            }
        }

        let sorted = buckets.sorted { $0.value > $1.value }.prefix(maxColors)
        return sorted.map { key, _ in
            let r = (key >> 16) & 0xFF
            let g = (key >> 8) & 0xFF
            let b = key & 0xFF
            return String(format: "#%02X%02X%02X", r, g, b)
        }
    }
}
