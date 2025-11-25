import SwiftUI
import SwiftData
import PhotosUI

@MainActor
final class OutfitTrackerViewModel: ObservableObject {
    @Published var outfits: [Outfit] = []
    @Published var isPickingImage: Bool = false
    @Published var isProcessing: Bool = false
    @Published var selectedImage: UIImage?
    @Published var extractedColors: [String] = []

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        loadOutfits()
    }

    func loadOutfits() {
        let descriptor = FetchDescriptor<Outfit>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        if let result = try? context.fetch(descriptor) {
            outfits = result
        }
    }

    func saveOutfit() {
        guard let image = selectedImage, let data = image.jpegData(compressionQuality: 0.8) else { return }
        let outfit = Outfit(imageData: data, colors: extractedColors, createdAt: Date())
        context.insert(outfit)
        try? context.save()
        loadOutfits()
    }

    func extractColors(from image: UIImage) {
        isProcessing = true
        Task {
            let hexColors = await SimpleColorExtractor.extractDominantColors(from: image, maxColors: 5)
            await MainActor.run {
                self.extractedColors = hexColors
                self.isProcessing = false
            }
        }
    }
}

struct OutfitTrackerView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: OutfitTrackerViewModel
    @State private var photoItem: PhotosPickerItem?

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: OutfitTrackerViewModel(context: modelContext))
    }

    var body: some View {
        ZStack {
            List {
                ForEach(viewModel.outfits) { outfit in
                    NavigationLink(destination: OutfitDetailView(outfit: outfit)) {
                        HStack(spacing: 12) {
                            outfitThumbnail(outfit)
                            HStack(spacing: 4) {
                                ForEach(outfit.colors.prefix(5), id: \.self) { hex in
                                    ColorSwatch(hex: hex)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Outfits")

            if viewModel.isProcessing {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                ProgressView("Extracting colors...")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    PhotosPicker(selection: $photoItem, matching: .images) {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(CreatiqTheme.fabGradient)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding()
                }
            }
        }
        .onChange(of: photoItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        viewModel.selectedImage = image
                        viewModel.extractColors(from: image)
                    }
                }
            }
        }
        .sheet(isPresented: Binding(
            get: { viewModel.selectedImage != nil && !viewModel.isProcessing },
            set: { if !$0 { viewModel.selectedImage = nil } }
        )) {
            if let image = viewModel.selectedImage {
                ConfirmOutfitView(viewModel: viewModel, image: image)
            }
        }
    }

    private func outfitThumbnail(_ outfit: Outfit) -> some View {
        Group {
            if let data = outfit.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                Image("outfit_placeholder")
                    .resizable()
            }
        }
        .scaledToFill()
        .frame(width: 64, height: 64)
        .clipped()
        .cornerRadius(12)
    }
}

struct ConfirmOutfitView: View {
    @ObservedObject var viewModel: OutfitTrackerViewModel
    let image: UIImage

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 260)
                    .cornerRadius(16)

                HStack(spacing: 8) {
                    ForEach(viewModel.extractedColors, id: \.self) { hex in
                        ColorSwatch(hex: hex)
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Confirm Outfit")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.saveOutfit()
                    }
                }
            }
        }
    }
}

struct ColorSwatch: View {
    let hex: String

    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color(hex: hex))
            .frame(width: 24, height: 24)
    }
}

struct OutfitDetailView: View {
    let outfit: Outfit

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let data = outfit.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(16)
                }

                HStack(spacing: 8) {
                    ForEach(outfit.colors, id: \.self) { hex in
                        Button(action: {
                            UIPasteboard.general.string = hex
                        }) {
                            ColorSwatch(hex: hex)
                        }
                    }
                }

                Spacer(minLength: 40)
            }
            .padding()
        }
        .navigationTitle("Outfit")
    }
}

enum SimpleColorExtractor {
    static func extractDominantColors(from image: UIImage, maxColors: Int) async -> [String] {
        guard let cgImage = image.cgImage else { return [] }
        let width = 60
        let height = 60

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)

        guard let context = CGContext(data: &pixelData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else { return [] }

        context.interpolationQuality = .low
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        var frequency: [UInt32: Int] = [:]

        for x in 0..<width {
            for y in 0..<height {
                let idx = (y * width + x) * bytesPerPixel
                let r = pixelData[idx]
                let g = pixelData[idx + 1]
                let b = pixelData[idx + 2]

                let key = (UInt32(r) << 16) | (UInt32(g) << 8) | UInt32(b)
                frequency[key, default: 0] += 1
            }
        }

        let sorted = frequency.sorted { $0.value > $1.value }.prefix(maxColors)
        return sorted.map { key, _ in
            String(format: "#%06X", key)
        }
    }
}

extension Color {
    init(hex: String) {
        var hex = hex
        if hex.hasPrefix("#") { hex.removeFirst() }
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xff) / 255
        let g = Double((int >> 8) & 0xff) / 255
        let b = Double(int & 0xff) / 255
        self.init(red: r, green: g, blue: b)
    }
}
