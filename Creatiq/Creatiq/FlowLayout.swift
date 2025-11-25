import SwiftUI

struct FlowLayout<Content: View>: View {
    let alignment: HorizontalAlignment
    let spacing: CGFloat
    @ViewBuilder let content: () -> Content

    init(alignment: HorizontalAlignment = .leading,
         spacing: CGFloat = 8,
         @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            content()
                .fixedSize()
                .alignmentGuide(.leading) { d in
                    if (abs(width - d.width) > geometry.size.width) {
                        width = 0
                        height -= d.height + spacing
                    }
                    let result = width
                    width -= d.width + spacing
                    return result
                }
                .alignmentGuide(.top) { _ in
                    let result = height
                    return result
                }
        }
    }
}

#Preview {
    FlowLayout(alignment: .leading, spacing: 6) {
        ForEach(["#aesthetic", "#outfit", "#moodboard", "#creatiq"], id: \.self) { tag in
            Text(tag)
                .padding(6)
                .background(Color.gray.opacity(0.2))
                .clipShape(Capsule())
        }
    }
    .padding()
}
