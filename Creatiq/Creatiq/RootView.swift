import SwiftUI
import SwiftData

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var showOnboarding: Bool = true

    var body: some View {
        Group {
            if showOnboarding {
                OnboardingFlowView(onFinished: handleOnboardingFinished)
            } else if !isLoggedIn {
                AuthFlowView()
            } else {
                MainTabView()
            }
        }
    }

    private func handleOnboardingFinished() {
        withAnimation(.easeInOut(duration: 0.25)) {
            showOnboarding = false
            hasCompletedOnboarding = true
        }
    }
}

#Preview {
    RootView()
        .modelContainer(for: Item.self, inMemory: true)
}
