//
//  MedibankCodingChallengeApp.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 9/2/2026.
//

import SwiftUI
import SwiftData
import Combine

/// Observable object containing global app settings and values.
final class AppSettings: ObservableObject {
    @AppStorage("isInitial") var isInitial = true
}

/// Cases for tab items.
enum TabKey: String {
    case headlines = "Headlines"
    case saved = "Saved"
    case sources = "Sources"
}

@main
struct MedibankCodingChallengeApp: App {
    @State private var selected: TabKey = .headlines
    @State private var tappedTwice = false
    @StateObject private var appSettings = AppSettings()
    
    var handler: Binding<TabKey> { Binding(
        get: { self.selected },
        set: {
            if $0 == selected {
                tappedTwice = true
            }
            
            self.selected = $0
        }
    )}
    
    @ViewBuilder
    private var tabView: some View {
        // Adds scrollToTop behavior by selecting the current view's tab item
        ScrollViewReader { proxy in
            TabView(selection: handler) {
                Tab(
                    TabKey.headlines.rawValue,
                    systemImage: "newspaper",
                    value: .headlines
                ) {
                    HeadlinesView()
                        .onChange(of: tappedTwice) { _, newValue in
                            if newValue {
                                withAnimation {
                                    proxy.scrollTo(TabKey.headlines.rawValue)
                                }
                                
                                tappedTwice = false
                            }
                        }
                        .tag(TabKey.headlines.rawValue)
                }
                
                Tab(
                    TabKey.sources.rawValue,
                    systemImage: "network",
                    value: .sources
                ) {
                    SourcesContainerView()
                        .onChange(of: tappedTwice) { _, newValue in
                            if newValue {
                                withAnimation {
                                    proxy.scrollTo(TabKey.sources.rawValue)
                                }
                                
                                tappedTwice = false
                            }
                        }
                        .tag(TabKey.sources.rawValue)
                }
                
                Tab(
                    TabKey.saved.rawValue,
                    systemImage: "bookmark",
                    value: .saved
                ) {
                    SavedArticlesView()
                        .onChange(of: tappedTwice) { _, newValue in
                            if newValue {
                                withAnimation {
                                    proxy.scrollTo(TabKey.saved.rawValue)
                                }
                                
                                tappedTwice = false
                            }
                        }
                        .tag(TabKey.saved.rawValue)
                }
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if appSettings.isInitial {
                OnboardingView()
                    .environmentObject(appSettings)
            } else {
                tabView
            }
        }
    }
}
