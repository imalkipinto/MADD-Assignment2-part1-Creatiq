import SwiftUI

enum CreatiqTheme {
    // Core brand colors
    static let peach = Color(red: 1.0, green: 0.80, blue: 0.90)
    static let lilac = Color(red: 0.79, green: 0.56, blue: 1.0)
    static let softPink = Color(red: 1.0, green: 0.59, blue: 0.77)
    static let softBackgroundTop = Color(red: 1.0, green: 0.95, blue: 0.99)
    static let softBackgroundBottom = Color(red: 0.98, green: 0.93, blue: 1.0)

    // Gradients
    static let primaryAccentGradient = LinearGradient(
        colors: [softPink, lilac],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let screenBackgroundGradient = LinearGradient(
        colors: [softBackgroundTop, softBackgroundBottom],
        startPoint: .top,
        endPoint: .bottom
    )

    static let fabGradient = LinearGradient(
        colors: [softPink, lilac],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let moodboardGradient = LinearGradient(
        colors: [Color(red: 0.99, green: 0.92, blue: 1.0), Color.white],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
