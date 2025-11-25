import SwiftUI
import SwiftData
import PhotosUI

@MainActor
final class PostPlannerViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isPresentingAddEdit: Bool = false
    @Published var editingPost: Post?
    @Published var selectedImage: UIImage?
    @Published var caption: String = ""
    @Published var date: Date = Date()
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    @Published var reuseWarning: String? = nil

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        loadPosts()
        NotificationManager.requestAuthorizationIfNeeded()
    }

    func loadPosts() {
        let descriptor = FetchDescriptor<Post>(sortBy: [SortDescriptor(\.date, order: .forward)])
        if let result = try? context.fetch(descriptor) {
            posts = result
        }
    }

    func prepareForNewPost() {
        editingPost = nil
        selectedImage = nil
        caption = ""
        date = Date()
        isPresentingAddEdit = true
    }

    func prepareForEdit(post: Post) {
        editingPost = post
        caption = post.caption
        date = post.date
        if let data = post.imageData, let image = UIImage(data: data) {
            selectedImage = image
        } else {
            selectedImage = nil
        }
        isPresentingAddEdit = true
    }

    func saveCurrentPost() {
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)

        // reuse detection: check for same caption in other posts
        let trimmed = caption.trimmingCharacters(in: .whitespacesAndNewlines)
        if let previous = posts.first(where: { $0.caption.trimmingCharacters(in: .whitespacesAndNewlines) == trimmed && $0.id != editingPost?.id }) {
            let dateString = previous.date.formatted(date: .abbreviated, time: .shortened)
            reuseWarning = "Similar caption used on \(dateString)."
        } else {
            reuseWarning = nil
        }

        if let editingPost {
            editingPost.caption = caption
            editingPost.date = date
            editingPost.imageData = imageData
            NotificationManager.cancelNotification(id: editingPost.id)
            NotificationManager.scheduleNotification(id: editingPost.id, title: "Scheduled Post", body: caption, date: date)
        } else {
            let post = Post(imageData: imageData, caption: caption, date: date)
            context.insert(post)
            NotificationManager.scheduleNotification(id: post.id, title: "Scheduled Post", body: caption, date: date)
        }

        try? context.save()
        loadPosts()
        isPresentingAddEdit = false
        show(message: "Saved")
    }

    func delete(at offsets: IndexSet) {
        for index in offsets {
            let post = posts[index]
            NotificationManager.cancelNotification(id: post.id)
            context.delete(post)
        }
        try? context.save()
        loadPosts()
        show(message: "Deleted")
    }

    private func show(message: String) {
        toastMessage = message
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showToast = false
        }
    }
}

struct PostPlannerView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: PostPlannerViewModel

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: PostPlannerViewModel(context: modelContext))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                ForEach(viewModel.posts) { post in
                    Button {
                        viewModel.prepareForEdit(post: post)
                    } label: {
                        HStack(spacing: 12) {
                            postThumbnail(post)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(post.caption)
                                    .font(.subheadline)
                                    .lineLimit(2)
                                Text(post.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                }
                .onDelete(perform: viewModel.delete)
            }
            .listStyle(.plain)
            .navigationTitle("Post Planner")

            Button {
                viewModel.prepareForNewPost()
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(CreatiqTheme.fabGradient)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            .padding()

            if viewModel.showToast {
                Text(viewModel.toastMessage)
                    .font(.caption)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .padding(.bottom, 90)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .sheet(isPresented: $viewModel.isPresentingAddEdit) {
            AddPostView(viewModel: viewModel)
        }
    }

    private func postThumbnail(_ post: Post) -> some View {
        Group {
            if let data = post.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                Image("todays_post_placeholder")
                    .resizable()
            }
        }
        .scaledToFill()
        .frame(width: 56, height: 56)
        .clipped()
        .cornerRadius(12)
    }
}

struct AddPostView: View {
    @ObservedObject var viewModel: PostPlannerViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var photoItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                PhotosPicker(selection: $photoItem, matching: .images) {
                    ZStack {
                        if let image = viewModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipped()
                                .cornerRadius(16)
                        } else {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.secondary.opacity(0.1))
                                .frame(height: 180)
                                .overlay(
                                    VStack(spacing: 8) {
                                        Image(systemName: "photo")
                                        Text("Tap to choose image")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                )
                        }
                    }
                }

                if let warning = viewModel.reuseWarning {
                    Text(warning)
                        .font(.caption)
                        .foregroundColor(Color(red: 0.80, green: 0.45, blue: 0.90))
                        .padding(8)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                }

                if let last = viewModel.posts.last {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Suggestion from your last post")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.secondary)
                        Text(last.caption)
                            .font(.caption)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                    }
                }

                TextEditor(text: $viewModel.caption)
                    .frame(minHeight: 120)
                    .padding(8)
                    .background(Color.secondary.opacity(0.06))
                    .cornerRadius(12)

                DatePicker("Schedule", selection: $viewModel.date, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)

                Spacer()
            }
            .padding()
            .navigationTitle(viewModel.editingPost == nil ? "New Post" : "Edit Post")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.saveCurrentPost()
                        dismiss()
                    }
                    .disabled(viewModel.caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onChange(of: photoItem) { _, newItem in
                guard let newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        await MainActor.run {
                            viewModel.selectedImage = image
                        }
                    }
                }
            }
        }
    }
}
