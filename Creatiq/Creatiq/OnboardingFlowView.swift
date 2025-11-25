import SwiftUI

struct OnboardingFlowView: View {
    @State private var currentPage: Int = 0
    var onFinished: (() -> Void)? = nil

    var body: some View {
        ZStack {
            CreatiqTheme.screenBackgroundGradient
                .ignoresSafeArea()

            TabView(selection: $currentPage) {
                WelcomeOnboardingView(nextAction: goToNext)
                    .tag(0)

                PlanningOnboardingView(nextAction: goToNext)
                    .tag(1)

                AICaptionOnboardingView(nextAction: goToNext)
                    .tag(2)

                OutfitOnboardingView(nextAction: goToNext)
                    .tag(3)

                MoodboardOnboardingView(finishAction: finish)
                    .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .ignoresSafeArea()
        }
    }

    private func goToNext() {
        withAnimation(.easeInOut(duration: 0.25)) {
            if currentPage < 4 {
                currentPage += 1
            }
        }
    }

    private func finish() {
        withAnimation(.easeInOut(duration: 0.25)) {
            onFinished?()
        }
    }
}

struct WelcomeOnboardingView: View {
    var nextAction: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 220, height: 220)
                        .shadow(color: Color.black.opacity(0.12), radius: 28, x: 0, y: 22)

                    Circle()
                        .stroke(LinearGradient(
                            colors: [Color(red: 0.79, green: 0.73, blue: 0.97), Color(red: 0.79, green: 0.90, blue: 1.0)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ), lineWidth: 12)
                        .frame(width: 260, height: 260)
                        .blur(radius: 1)
                        .opacity(0.7)

                    Circle()
                        .stroke(LinearGradient(
                            colors: [Color(red: 0.79, green: 0.73, blue: 0.97), Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        ), lineWidth: 4)
                        .frame(width: 180, height: 180)
                        .opacity(0.8)

                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                }


                VStack(spacing: 12) {
                    Text("Welcome to Creatiq")
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .tracking(2)
                        .foregroundColor(Color(red: 0.12, green: 0.10, blue: 0.09))
                        .multilineTextAlignment(.center)

                    Text("Craft premium content. Create your aesthetic. Influence with intention.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.black.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Spacer()

                VStack(spacing: 16) {
                    Button(action: nextAction) {
                        Text("Get Started")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                ZStack {
                                    Color.purple.opacity(0.5)
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                }
                            )
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.18), radius: 20, x: 0, y: 16)
                    }
                    .padding(.horizontal, 24)

                    Button(action: {}) {
                        Text("Already have an account? Sign Up")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color.black.opacity(0.6))
                    }
                    .padding(.bottom, 8)
                }
                .padding(.bottom, 24)
            }
        }
    }
}

struct PlanningOnboardingView: View {
    var nextAction: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 24) {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 14)
                        .overlay(
                            VStack(spacing: 16) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(Color(red: 0.68, green: 0.49, blue: 0.98))
                                    Text("This Week")
                                        .font(.headline)
                                    Spacer()
                                }

                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color(red: 0.96, green: 0.89, blue: 1.0))
                                            .frame(width: 6, height: 28)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Today • 2:00 PM")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Text("Post: Living my best life ✨")
                                                .font(.subheadline)
                                        }
                                        Spacer()
                                    }

                                    HStack {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color(red: 1.0, green: 0.93, blue: 0.86))
                                            .frame(width: 6, height: 28)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Tomorrow • 6:30 PM")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Text("Reel: Outfit recap")
                                                .font(.subheadline)
                                        }
                                        Spacer()
                                    }

                                    HStack {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color(red: 0.89, green: 0.95, blue: 1.0))
                                            .frame(width: 6, height: 28)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Friday • 10:00 AM")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Text("Story set: BTS snippets")
                                                .font(.subheadline)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            .padding(22)
                        )
                        .padding(.horizontal, 32)
                }

                VStack(spacing: 12) {
                    Text("Plan & Schedule Like a Pro")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color.black.opacity(0.9))
                        .multilineTextAlignment(.center)

                    Text("Visualize your week, batch your ideas, and never miss a post.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.black.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Spacer()

                Button(action: nextAction) {
                    Text("Next")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 1.0, green: 0.75, blue: 0.90), Color(red: 0.75, green: 0.56, blue: 1.0)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .shadow(color: Color(red: 0.75, green: 0.56, blue: 1.0).opacity(0.45), radius: 22, x: 0, y: 12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}

struct AICaptionOnboardingView: View {
    var nextAction: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                Spacer()

                ZStack {
                    

                    Image("insta")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.7)
                        .frame(width: 270, height: 240)
                }

                VStack(spacing: 12) {
                    Text("AI Caption Studio")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(Color.black.opacity(0.9))
                        .multilineTextAlignment(.center)

                    Text("Generate aesthetic captions and hashtags in seconds.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.black.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Spacer()

                Button(action: nextAction) {
                    Text("Next")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color.white.opacity(0.9))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Color.purple.opacity(0.5)
                        )
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(LinearGradient(
                                    colors: [Color(red: 0.79, green: 0.73, blue: 0.97), Color(red: 0.79, green: 0.90, blue: 1.0)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.12), radius: 18, x: 0, y: 10)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}

struct OutfitOnboardingView: View {
    var nextAction: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(Color.white.opacity(0.9))
                        .shadow(color: Color.black.opacity(0.15), radius: 26, x: 0, y: 18)

                    VStack(spacing: 18) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.black.opacity(0.8))
                            .frame(width: 120, height: 2)

                        HStack(spacing: 10) {
                            Image("outfit_1")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 90)
                                .clipped()
                                .cornerRadius(14)

                            Image("outfit_2")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 90)
                                .clipped()
                                .cornerRadius(14)

                            Image("outfit_3")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 90)
                                .clipped()
                                .cornerRadius(14)
                        }
                    }
                    .padding(24)
                }
                .frame(height: 220)
                .padding(.horizontal, 32)

                VStack(spacing: 12) {
                    Text("Track Your Outfits in Style")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color.black.opacity(0.9))
                        .multilineTextAlignment(.center)

                    Text("Document your looks and discover your color palette.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.black.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Spacer()

                Button(action: nextAction) {
                    Text("Continue")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.white.opacity(0.9))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color.black.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 16, x: 0, y: 8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}

struct MoodboardOnboardingView: View {
    var finishAction: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                Spacer()

                ZStack {
                    Image("todays_post_image")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 220, height: 160)
                        .clipped()
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.14), radius: 20, x: 0, y: 16)

                    Image("outfit_1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 110)
                        .clipped()
                        .cornerRadius(16)
                        .rotationEffect(.degrees(-8))
                        .offset(x: -70, y: 40)

                    Image("outfit_2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 110)
                        .clipped()
                        .cornerRadius(16)
                        .rotationEffect(.degrees(10))
                        .offset(x: 70, y: -40)
                }
                .padding(.horizontal, 24)

                VStack(spacing: 12) {
                    Text("Build Your Moodboard")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color.black.opacity(0.9))
                        .multilineTextAlignment(.center)

                    Text("Collect inspirations and craft your creative universe.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.black.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Spacer()

                Button(action: finishAction) {
                    Text("Finish")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Color.white.opacity(0.6)
                        )
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(LinearGradient(
                                    colors: [Color(red: 0.93, green: 0.84, blue: 0.70), Color(red: 0.98, green: 0.91, blue: 0.79)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 18, x: 0, y: 10)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    OnboardingFlowView()
}
