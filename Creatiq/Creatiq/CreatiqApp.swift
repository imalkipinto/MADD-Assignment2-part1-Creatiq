//
//  CreatiqApp.swift
//  Creatiq
//
//  Created by salani nethmika rubasing jayawardhana on 2025-11-22.
//

import SwiftUI
import SwiftData

@main
struct CreatiqApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Post.self,
            Outfit.self,
            MoodboardItem.self,
            AICaptionHistory.self,
            AIScriptIdea.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}
