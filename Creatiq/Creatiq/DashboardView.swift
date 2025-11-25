import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: DashboardViewModel
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var showingProfileSheet: Bool = false
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("userEmail") private var userEmail: String = ""

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(modelContext: modelContext))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    todaysPostSection
                    quickActionsSection
                    recentOutfitsSection
                }
        .sheet(isPresented: $showingProfileSheet) {
            NavigationStack {
                VStack(alignment: .leading, spacing: 24) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(userName.isEmpty ? "Creator" : userName)
                            .font(.title3.weight(.semibold))
                        if !userEmail.isEmpty {
                            Text(userEmail)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }

                    Button(role: .destructive) {
                        isLoggedIn = false
                    } label: {
                        Text("Log Out")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }

                    Spacer()
                }
                .padding()
                .navigationTitle("Account")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") { showingProfileSheet = false }
                    }
                }
            }
        }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 32)
            }
            .background(
                CreatiqTheme.screenBackgroundGradient
                    .ignoresSafeArea()
            )
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    viewModel.loadTodayPost()
                    viewModel.loadRecentOutfits()
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 12) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text("Hi, \(userName.isEmpty ? "Creator" : userName)")
                        .font(.title3.weight(.semibold))
                    Text("Welcome back to Creatiq")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                HStack(spacing: 12) {
                    Button {
                        showingProfileSheet = true
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.primary)
                    }
                    Image(systemName: "gearshape")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color(red: 0.76, green: 0.42, blue: 0.98))
                }
            }
        }
    }

    private var todaysPostSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Scheduled Post")
                .font(.headline)

            Group {
                if let post = viewModel.todayPost {
                    NavigationLink {
                        PostDetailView(post: post)
                    } label: {
                        HStack(alignment: .top, spacing: 14) {
                            postImage(for: post)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(post.date, style: .time)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(post.caption)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .lineLimit(2)
                                HStack(spacing: 4) {
                                    Text("Open")
                                        .font(.caption)
                                        .foregroundColor(Color(red: 0.75, green: 0.42, blue: 0.98))
                                    Image(systemName: "chevron.right")
                                        .font(.caption2)
                                        .foregroundColor(Color(red: 0.75, green: 0.42, blue: 0.98))
                                }
                            }

                            Spacer()
                        }
                    }
                    .accessibilityLabel("Today's scheduled post at \(post.date.formatted(date: .omitted, time: .shortened))")
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("No post scheduled for today")
                            .font(.subheadline.weight(.semibold))
                        Text("Stay consistent by planning your next post.")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        NavigationLink {
                            PostPlannerView(modelContext: modelContext)
                        } label: {
                            Text("Create Post")
                                .font(.footnote.weight(.semibold))
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(
                                    LinearGradient(
                                        colors: [Color(red: 1.0, green: 0.59, blue: 0.77),
                                                 Color(red: 0.79, green: 0.53, blue: 1.0)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                        }
                    }
                }
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.98, green: 0.90, blue: 1.0),
                             Color.white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.white.opacity(0.8), lineWidth: 1)
            )
            .cornerRadius(22)
            .shadow(color: Color(red: 0.70, green: 0.43, blue: 0.84).opacity(0.18), radius: 18, x: 0, y: 12)
            .accessibilityElement(children: .contain)
        }
    }

    private func postImage(for post: Post) -> some View {
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
        .frame(width: 74, height: 74)
        .clipped()
        .cornerRadius(16)
    }

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)

            HStack(spacing: 14) {
                NavigationLink(destination: PostPlannerView(modelContext: modelContext)) {
                    quickActionCard(icon: "plus", title: "New Post")
                }
                NavigationLink(destination: AICaptionGeneratorView()) {
                    quickActionCard(icon: "sparkles", title: "AI Caption")
                }
                NavigationLink(destination: MoodboardView(modelContext: modelContext)) {
                    quickActionCard(icon: "square.grid.2x2", title: "Moodboard")
                }
            }
        }
    }

    private func quickActionCard(icon: String, title: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(red: 0.75, green: 0.42, blue: 0.98))

            Text(title)
                .font(.footnote)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(.ultraThinMaterial)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
        .scaleEffect(1.0)
    }

    private var recentOutfitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Outfits")
                    .font(.headline)
                Spacer()
                Button(action: {}) {
                    Text("View All")
                        .font(.footnote)
                        .foregroundColor(Color(red: 0.75, green: 0.42, blue: 0.98))
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    if viewModel.recentOutfits.isEmpty {
                        outfitPlaceholderCard
                    } else {
                        ForEach(viewModel.recentOutfits) { outfit in
                            NavigationLink(destination: OutfitDetailView(outfit: outfit)) {
                                outfitCard(outfit: outfit)
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
                .animation(.easeInOut, value: viewModel.recentOutfits.count)
            }
        }
    }

    private var outfitPlaceholderCard: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(Color.white.opacity(0.6))
            .frame(width: 120, height: 170)
            .overlay(
                VStack(spacing: 6) {
                    Image(systemName: "photo")
                        .font(.system(size: 22))
                        .foregroundColor(.secondary)
                    Text("Add your first outfit")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
            )
    }

    private func outfitCard(outfit: Outfit) -> some View {
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
        .frame(width: 120, height: 170)
        .clipped()
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.16), radius: 14, x: 0, y: 10)
    }

}

struct PostDetailView: View {
    let post: Post

    var body: some View {
        Text(post.caption)
            .padding()
            .navigationTitle("Post Details")
    }
}

#Preview {
    let container = try! ModelContainer(for: Post.self, Outfit.self)
    let context = ModelContext(container)
    return DashboardView(modelContext: context)
}
