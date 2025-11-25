import SwiftUI
import SwiftData

@MainActor
final class AICaptionViewModel: ObservableObject {
    enum Tone: String, CaseIterable, Identifiable {
        case funny = "Funny"
        case aesthetic = "Aesthetic"
        case minimal = "Minimal"
        case bold = "Bold"

        var id: String { rawValue }
    }

    @Published var topic: String = ""
    @Published var captionDetails: String = ""       // what the caption is about
    @Published var desiredLength: String = "Medium"  // Short / Medium / Long
    @Published var tone: Tone = .aesthetic
    @Published var isGenerating: Bool = false
    @Published var caption: String = ""
    @Published var hashtags: String = ""
    @Published var reuseMessage: String? = nil
    @Published var lastSuggestion: String? = nil

    // Idea -> script & shooting plan
    @Published var ideaText: String = ""
    @Published var generatedScript: String = ""
    @Published var shootingSuggestions: String = ""
    @Published var isGeneratingScript: Bool = false

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        loadLastSuggestion()
    }

    func generate() async {
        guard !topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        await MainActor.run { isGenerating = true }

        do {
            let gemini = try await GeminiClient.generateCaption(
                topic: topic,
                details: captionDetails,
                desiredLength: desiredLength,
                tone: tone.rawValue
            )
            let wrapped = AICaptionModelResult(caption: gemini.caption, hashtags: gemini.hashtags)
            handleResult(wrapped)
        } catch {
            let fallback = AICaptionModel.fallback(topic: topic, tone: tone.rawValue)
            handleResult(fallback)
        }
    }

    func generateScript() async {
        let trimmedIdea = ideaText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedIdea.isEmpty else { return }

        await MainActor.run { isGeneratingScript = true }

        do {
            let result = try await GeminiClient.generateScript(for: trimmedIdea)

            await MainActor.run {
                self.generatedScript = result.script
                self.shootingSuggestions = result.shootingSuggestions
                self.isGeneratingScript = false
            }

            let entry = AIScriptIdea(
                idea: trimmedIdea,
                script: result.script,
                shootingSuggestions: result.shootingSuggestions
            )
            context.insert(entry)
            try? context.save()
        } catch {
            await MainActor.run {
                self.isGeneratingScript = false
            }
        }
    }

    private func handleResult(_ result: AICaptionModelResult) {
        Task { @MainActor in
            self.caption = result.caption
            self.hashtags = result.hashtags
            self.isGenerating = false

            saveHistory(topic: self.topic, tone: self.tone.rawValue, result: result)
            detectReuse(for: result.caption)
        }
    }

    private func saveHistory(topic: String, tone: String, result: AICaptionModelResult) {
        let entry = AICaptionHistory(topic: topic, tone: tone, caption: result.caption, hashtags: result.hashtags)
        context.insert(entry)
        try? context.save()
        loadLastSuggestion()
    }

    private func detectReuse(for newCaption: String) {
        let trimmed = newCaption.trimmingCharacters(in: .whitespacesAndNewlines)
        var descriptor = FetchDescriptor<AICaptionHistory>(
            predicate: #Predicate { $0.caption == trimmed },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = 2

        if let results = try? context.fetch(descriptor), results.count > 1 {
            if let previous = results.dropFirst().first {
                let dateString = previous.createdAt.formatted(date: .abbreviated, time: .shortened)
                reuseMessage = "Similar caption used before on \(dateString)."
                return
            }
        }
        reuseMessage = nil
    }

    private func loadLastSuggestion() {
        var descriptor = FetchDescriptor<AICaptionHistory>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        if let last = try? context.fetch(descriptor).first {
            lastSuggestion = "Last: \(last.caption)"
        }
    }
}

struct AICaptionGeneratorView: View {
    @StateObject private var viewModel = AICaptionViewModel(
        context: ModelContext(try! ModelContainer(for: AICaptionHistory.self, AIScriptIdea.self))
    )

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("AI Caption Studio")
                    .font(.title2.weight(.semibold))

                TextField("Topic (e.g. sunset by the beach)", text: $viewModel.topic)
                    .textFieldStyle(.roundedBorder)

                TextField("What is this caption about?", text: $viewModel.captionDetails, axis: .vertical)
                    .textFieldStyle(.roundedBorder)

                TextField("Desired length (Short, Medium, Long)", text: $viewModel.desiredLength)
                    .textFieldStyle(.roundedBorder)

                Picker("Tone", selection: $viewModel.tone) {
                    ForEach(AICaptionViewModel.Tone.allCases) { tone in
                        Text(tone.rawValue).tag(tone)
                    }
                }
                .pickerStyle(.segmented)

                if let last = viewModel.lastSuggestion {
                    Text(last)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Button {
                    Task { await viewModel.generate() }
                } label: {
                    HStack {
                        if viewModel.isGenerating {
                            ProgressView()
                        }
                        Text(viewModel.isGenerating ? "Generating..." : "Generate")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(CreatiqTheme.primaryAccentGradient)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                .disabled(viewModel.isGenerating)

                if let reuse = viewModel.reuseMessage {
                    Text(reuse)
                        .font(.caption)
                        .foregroundColor(Color(red: 0.75, green: 0.42, blue: 0.98))
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                }

                if !viewModel.caption.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Caption")
                            .font(.headline)
                        Text(viewModel.caption)
                            .font(.body)
                        Button("Copy Caption") {
                            UIPasteboard.general.string = viewModel.caption
                        }
                    }
                }

                if !viewModel.hashtags.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hashtags")
                            .font(.headline)
                        Text(viewModel.hashtags)
                            .font(.body)
                        Button("Copy Hashtags") {
                            UIPasteboard.general.string = viewModel.hashtags
                        }
                        Button("Copy All") {
                            UIPasteboard.general.string = viewModel.caption + "\n\n" + viewModel.hashtags
                        }
                    }
                }

                Divider()
                    .padding(.vertical, 16)

                // Idea -> script & shooting suggestions
                Text("Content Idea → Script & Shoot Plan")
                    .font(.headline)

                TextField("Describe your content idea (e.g. GRWM for a brand event)", text: $viewModel.ideaText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)

                Button {
                    Task { await viewModel.generateScript() }
                } label: {
                    HStack {
                        if viewModel.isGeneratingScript {
                            ProgressView()
                        }
                        Text(viewModel.isGeneratingScript ? "Generating Script..." : "Generate Script & Suggestions")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(CreatiqTheme.primaryAccentGradient)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                .disabled(viewModel.isGeneratingScript)

                if !viewModel.generatedScript.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Script")
                            .font(.headline)
                        Text(viewModel.generatedScript)
                            .font(.body)
                    }
                    .padding(.top, 8)
                }

                if !viewModel.shootingSuggestions.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Shooting Suggestions")
                            .font(.headline)
                        Text(viewModel.shootingSuggestions)
                            .font(.body)
                    }
                    .padding(.top, 4)
                }

                Spacer(minLength: 40)
            }
            .padding()
        }
        .background(CreatiqTheme.screenBackgroundGradient.ignoresSafeArea())
        .navigationTitle("AI Caption")
    }
}

struct AICaptionModelResult {
    let caption: String
    let hashtags: String
}

actor AICaptionModel {
    static let shared = AICaptionModel()

    func predict(topic: String, tone: String) async throws -> AICaptionModelResult {
        try await Task.sleep(nanoseconds: 500_000_000)
        return AICaptionModel.fallback(topic: topic, tone: tone)
    }

    static func fallback(topic: String, tone: String) -> AICaptionModelResult {
        let base = topic.trimmingCharacters(in: .whitespacesAndNewlines)
        let caption: String
        let tags: [String]

        switch tone.lowercased() {
        case "funny":
            caption = "Just \(base) things 😂"
            tags = ["#funny", "#meme", "#lol", "#creatiq"]
        case "minimal":
            caption = base
            tags = ["#minimal", "#clean", "#aesthetic", "#creatiq"]
        case "bold":
            caption = base.uppercased() + " ✨"
            tags = ["#bold", "#statement", "#creatiq"]
        default:
            caption = "Soft \(base) vibes"
            tags = ["#aesthetic", "#vibes", "#creatiq"]
        }

        let hashtags = tags.joined(separator: " ")
        return AICaptionModelResult(caption: caption, hashtags: hashtags)
    }
}
