import Foundation
import SwiftData

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var todayPost: Post?
    @Published var recentOutfits: [Outfit] = []
    @Published var errorMessage: String?

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func loadTodayPost() {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        guard let endOfDay = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay) else { return }

        var descriptor = FetchDescriptor<Post>(
            predicate: #Predicate { post in
                post.date >= startOfDay && post.date <= endOfDay
            },
            sortBy: [SortDescriptor(\.date, order: .forward)]
        )
        descriptor.fetchLimit = 1

        let result = try? modelContext.fetch(descriptor)
        self.todayPost = result?.first
    }

    func loadRecentOutfits() {
        var descriptor = FetchDescriptor<Outfit>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = 10

        let result = try? modelContext.fetch(descriptor)
        recentOutfits = result ?? []
    }
}
