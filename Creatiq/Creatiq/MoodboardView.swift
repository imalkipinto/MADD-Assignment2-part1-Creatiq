import SwiftUI
import SwiftData
import PhotosUI

struct MoodboardView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: MoodboardViewModel

    @State private var photoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var editingItem: MoodboardItem?
    @State private var note: String = ""
    @State private var selectedAudio: String = ""
    @State private var showAddSheet: Bool = false
    @State private var showFullscreen: Bool = false
    @State private var fullscreenItem: MoodboardItem?

    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 14)
    ]

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: MoodboardViewModel(context: modelContext))
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 18) {
                    ForEach(Array(viewModel.items.enumerated()), id: \.element.id) { index, item in
                        moodboardCard(for: item, index: index)
                            .onTapGesture {
                                fullscreenItem = item
                                showFullscreen = true
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    viewModel.deleteItem(item)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }

                                Button {
                                    prepareEdit(for: item)
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 80)
            }

            if let message = viewModel.trendingMessage {
                trendingPopup(message: message)
                    .padding(.top, 8)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            PhotosPicker(selection: $photoItem, matching: .images) {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 58, height: 58)
                    .background(CreatiqTheme.fabGradient)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.2), radius: 14, x: 0, y: 10)
                    .padding()
                    .scaleEffect(viewModel.isLoading ? 0.9 : 1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.isLoading)
            }
        }
        .navigationTitle("Moodboard")
        .onAppear {
            viewModel.loadItems()
        }
        .onChange(of: photoItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        selectedImage = image
                        editingItem = nil
                        note = ""
                        selectedAudio = ""
                        showAddSheet = true
                    }
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            if let image = selectedImage {
                AddMoodboardView(
                    image: image,
                    note: $note,
                    selectedAudio: $selectedAudio,
                    isEditing: editingItem != nil,
                    onSave: { note, audio in
                        if let editingItem {
                            viewModel.updateItem(editingItem, note: note, audioChoice: audio)
                        } else {
                            viewModel.addItem(image: image, note: note, audioChoice: audio)
                        }
                    }
                )
            }
        }
        .fullScreenCover(isPresented: $showFullscreen) {
            if let item = fullscreenItem {
                fullscreenViewer(for: item)
            }
        }
    }

    private func prepareEdit(for item: MoodboardItem) {
        editingItem = item
        note = item.note
        selectedAudio = item.audioURL ?? ""
        if let data = item.imageData, let uiImage = UIImage(data: data) {
            selectedImage = uiImage
            showAddSheet = true
        }
    }

    private func moodboardCard(for item: MoodboardItem, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottomLeading) {
                Group {
                    if let data = item.imageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.secondary.opacity(0.1))
                    }
                }
                .frame(height: index.isMultiple(of: 2) ? 230 : 180)
                .clipped()
                .cornerRadius(20)

                VStack(alignment: .leading, spacing: 6) {
                    if !item.tag.isEmpty {
                        Text(item.tag)
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                    }

                    HStack(spacing: 6) {
                        ForEach(item.dominantColors.prefix(3), id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 10, height: 10)
                        }

                        Spacer()

                        if item.audioURL != nil {
                            Button {
                                viewModel.playAudio(for: item)
                            } label: {
                                Image(systemName: viewModel.currentlyPlayingID == item.id ? "pause.fill" : "play.fill")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
                .padding(10)
            }
            .shadow(color: Color.black.opacity(0.16), radius: 16, x: 0, y: 10)

            if !item.themes.isEmpty {
                FlowLayout(alignment: HorizontalAlignment.leading, spacing: 6) {
                    ForEach(item.themes, id: \.self) { theme in
                        Text("#" + theme)
                            .font(.caption2)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color(.systemBackground).opacity(0.9))
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                }
            } else if !item.note.isEmpty {
                Text(item.note)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .scaleEffect(0.98)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.items.count)
    }

    private func trendingPopup(message: String) -> some View {
        HStack(spacing: 10) {
            Text("🔥")
            VStack(alignment: .leading, spacing: 2) {
                Text("Trending Moodboard")
                    .font(.caption.bold())
                Text(message)
                    .font(.caption2)
            }
            Spacer()
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .background(
            CreatiqTheme.moodboardGradient
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .padding(.horizontal)
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    private func fullscreenViewer(for item: MoodboardItem) -> some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()

                VStack(spacing: 20) {
                    if let data = item.imageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(24)
                            .shadow(color: Color.black.opacity(0.2), radius: 24, x: 0, y: 16)
                            .padding(.horizontal)
                    }

                    if !item.themes.isEmpty {
                        FlowLayout(alignment: HorizontalAlignment.leading, spacing: 8) {
                            ForEach(item.themes, id: \.self) { theme in
                                Text("#" + theme)
                                    .font(.caption)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 10)
                                    .background(.thinMaterial)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal)
                    }

                    HStack(spacing: 8) {
                        ForEach(item.dominantColors, id: \.self) { hex in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: hex))
                                .frame(width: 40, height: 18)
                        }
                    }

                    if !item.note.isEmpty {
                        Text(item.note)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    if item.audioURL != nil {
                        Button {
                            viewModel.playAudio(for: item)
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: viewModel.currentlyPlayingID == item.id ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.system(size: 26))
                                Text(viewModel.currentlyPlayingID == item.id ? "Pause vibe track" : "Play vibe track")
                                    .font(.subheadline.bold())
                            }
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                        }
                    }

                    Spacer()
                }
                .padding(.top, 20)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        showFullscreen = false
                        fullscreenItem = nil
                    }
                }
            }
        }
    }
}

struct AddMoodboardView: View {
    let image: UIImage
    @Binding var note: String
    @Binding var selectedAudio: String
    var isEditing: Bool
    var onSave: (String, String) -> Void
    @Environment(\.dismiss) private var dismiss

    private let audioOptions: [String] = [
        "soft_beats.mp3",
        "night_city.mp3",
        "pastel_dreams.mp3",
        ""
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)

                TextField("Add a note or vibe tag", text: $note)
                    .textFieldStyle(.roundedBorder)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Vibe track")
                        .font(.footnote)
                        .foregroundColor(.secondary)

                    Picker("Vibe track", selection: $selectedAudio) {
                        Text("None").tag("")
                        Text("Soft Beats").tag("soft_beats.mp3")
                        Text("Night City").tag("night_city.mp3")
                        Text("Pastel Dreams").tag("pastel_dreams.mp3")
                    }
                    .pickerStyle(.menu)
                }

                Spacer()
            }
            .padding()
            .navigationTitle(isEditing ? "Edit Moodboard" : "Add to Moodboard")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(note, selectedAudio)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: MoodboardItem.self)
    let context = ModelContext(container)
    return MoodboardView(modelContext: context)
}
