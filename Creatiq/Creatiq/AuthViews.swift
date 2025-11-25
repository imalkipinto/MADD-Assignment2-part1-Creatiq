import SwiftUI

struct AuthFlowView: View {
    @State private var showSignUp: Bool = false

    var body: some View {
        if showSignUp {
            SignUpView(switchToLogin: { withAnimation { showSignUp = false } })
        } else {
            LoginView(switchToSignUp: { withAnimation { showSignUp = true } })
        }
    }
}

struct LoginView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userName") private var storedUserName: String = ""
    @AppStorage("userEmail") private var storedUserEmail: String = ""

    @State private var email: String = ""
    @State private var password: String = ""

    var switchToSignUp: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 16) {
                Image("creatiq_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)

                Text("Welcome back to Creatiq")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
            }

            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    TextField("name@example.com", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .padding(14)
                        .background(.thinMaterial)
                        .cornerRadius(14)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    SecureField("••••••••", text: $password)
                        .textContentType(.password)
                        .padding(14)
                        .background(.thinMaterial)
                        .cornerRadius(14)
                }

                Button(action: {
                    storedUserEmail = email
                    if storedUserName.isEmpty {
                        let base = email.split(separator: "@").first ?? "Creator"
                        let name = base.isEmpty ? "Creator" : String(base)
                        storedUserName = name.prefix(1).uppercased() + name.dropFirst()
                    }
                    isLoggedIn = true
                }) {
                    Text("Log In")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 1.0, green: 0.59, blue: 0.77),
                                         Color(red: 0.79, green: 0.53, blue: 1.0)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(20)
                        .shadow(color: Color(red: 0.86, green: 0.53, blue: 0.93).opacity(0.5), radius: 18, x: 0, y: 10)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 24)

            Spacer()

            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .foregroundColor(.secondary)
                Button(action: switchToSignUp) {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.82))
                }
            }
            .padding(.bottom, 24)
        }
        .padding(.top, 32)
        .background(
            CreatiqTheme.screenBackgroundGradient
                .ignoresSafeArea()
        )
    }
}

struct SignUpView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userName") private var storedUserName: String = ""
    @AppStorage("userEmail") private var storedUserEmail: String = ""

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    var switchToLogin: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 16) {
                Image("creatiq_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)

                Text("Create your Creatiq account")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
            }

            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Full Name")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    TextField("Your name", text: $name)
                        .textContentType(.name)
                        .padding(14)
                        .background(.thinMaterial)
                        .cornerRadius(14)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    TextField("name@example.com", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .padding(14)
                        .background(.thinMaterial)
                        .cornerRadius(14)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    SecureField("Create a password", text: $password)
                        .textContentType(.newPassword)
                        .padding(14)
                        .background(.thinMaterial)
                        .cornerRadius(14)
                }

                Button(action: { isLoggedIn = true }) {
                    Text("Sign Up")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.99, green: 0.69, blue: 0.76),
                                         Color(red: 0.81, green: 0.56, blue: 1.0)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(20)
                        .shadow(color: Color(red: 0.86, green: 0.53, blue: 0.93).opacity(0.5), radius: 18, x: 0, y: 10)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 24)

            Spacer()

            HStack(spacing: 4) {
                Text("Already have an account?")
                    .foregroundColor(.secondary)
                Button(action: switchToLogin) {
                    Text("Log In")
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.82))
                }
            }
            .padding(.bottom, 24)
        }
        .padding(.top, 32)
        .background(
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.95, blue: 0.98),
                         Color(red: 0.96, green: 0.94, blue: 1.0)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

#Preview {
    AuthFlowView()
}
