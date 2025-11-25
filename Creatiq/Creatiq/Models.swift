import Foundation
import SwiftData

@Model
final class Post {
    @Attribute(.unique) var id: UUID
    var imageData: Data?
    var caption: String
    var date: Date

    init(id: UUID = UUID(), imageData: Data? = nil, caption: String, date: Date) {
        self.id = id
        self.imageData = imageData
        self.caption = caption
        self.date = date
    }
}

@Model
final class Outfit {
    @Attribute(.unique) var id: UUID
    var imageData: Data?
    var colors: [String]
    var createdAt: Date

    init(id: UUID = UUID(), imageData: Data? = nil, colors: [String] = [], createdAt: Date = .now) {
        self.id = id
        self.imageData = imageData
        self.colors = colors
        self.createdAt = createdAt
    }
}

@Model
final class MoodboardItem {
    @Attribute(.unique) var id: UUID
    var imageData: Data?
    var note: String
    var createdAt: Date
    var tag: String
    var themes: [String]
    var dominantColors: [String]
    var audioURL: String?

    init(
        id: UUID = UUID(),
        imageData: Data? = nil,
        note: String = "",
        createdAt: Date = .now,
        tag: String = "",
        themes: [String] = [],
        dominantColors: [String] = [],
        audioURL: String? = nil
    ) {
        self.id = id
        self.imageData = imageData
        self.note = note
        self.createdAt = createdAt
        self.tag = tag
        self.themes = themes
        self.dominantColors = dominantColors
        self.audioURL = audioURL
    }
}

@Model
final class AICaptionHistory {
    @Attribute(.unique) var id: UUID
    var topic: String
    var tone: String
    var caption: String
    var hashtags: String
    var createdAt: Date

    init(id: UUID = UUID(), topic: String, tone: String, caption: String, hashtags: String, createdAt: Date = .now) {
        self.id = id
        self.topic = topic
        self.tone = tone
        self.caption = caption
        self.hashtags = hashtags
        self.createdAt = createdAt
    }
}

@Model
final class AIScriptIdea {
    @Attribute(.unique) var id: UUID
    var idea: String
    var script: String
    var shootingSuggestions: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        idea: String,
        script: String,
        shootingSuggestions: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.idea = idea
        self.script = script
        self.shootingSuggestions = shootingSuggestions
        self.createdAt = createdAt
    }
}
