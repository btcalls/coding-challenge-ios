//
//  OnboardingView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 13/2/2026.
//

import SwiftUI

/// View to be presented initially to configure sources to be used for fetching articles.
struct OnboardingView: View {
    @EnvironmentObject private var appSettings: AppSettings
    @StateObject private var viewModel = SourcesViewModel(
        container: SwiftDataManager.shared.container
    )
    
    var additionalInfo: String {
        return "To get stared, please select the news sources you would like to fetch articles from."
    }
    
    var body: some View {
        NavigationStack {
            SourcesView(
                viewModel,
                mode: .edit,
                additionalInfo: additionalInfo,
                emptyViewActions: {
                    Button(action: {
                        Task {
                            await viewModel.fetchSources()
                        }
                    }, label: {
                        Text("Get Sources")
                            .buttonTextStyle()
                    })
                    .buttonStyle(.glassProminent)
                }
            )
                .navigationTitle("Welcome!")
                .safeAreaBar(edge: .bottom) {
                    if !viewModel.data.isEmpty {
                        Button(action: {
                            do {
                                try viewModel.saveSelectedSources()
                                
                                appSettings.isInitial = false
                            } catch {
                                appSettings.isInitial = true
                            }
                        }, label: {
                            Label("Proceed to Headlines", systemImage: "newspaper.fill")
                                .buttonTextStyle()
                                .frame(maxWidth: .infinity)
                        })
                        .buttonStyle(.glassProminent)
                        .padding(.horizontal, Layout.Padding.regular)
                        .disabled(viewModel.selectedCount == 0)
                    }
                }
        }
        .padding(.horizontal, Layout.Padding.comfortable)
        .task(id: "initial-fetch-sources") {
            await viewModel.fetchSources()
        }
    }
}

#Preview {
    OnboardingView()
}
