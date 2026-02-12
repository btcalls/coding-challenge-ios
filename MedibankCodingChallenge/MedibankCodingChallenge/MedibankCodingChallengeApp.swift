//
//  MedibankCodingChallengeApp.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 9/2/2026.
//

import SwiftUI
import SwiftData

enum TabKey: String {
    case headlines = "Headlines"
    case saved = "Saved"
    case sources = "Sources"
}

@main
struct MedibankCodingChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab(TabKey.headlines.rawValue, systemImage: "newspaper") {
                    HeadlinesView()
                }
                
                Tab(TabKey.sources.rawValue, systemImage: "network") {
                    SourcesContainerView()
                }
                
                Tab(TabKey.saved.rawValue, systemImage: "bookmark") {
                    SavedArticlesView()
                }
            }
        }
    }
}
