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
    @StateObject private var viewModel = SourcesViewModel()
    
    var body: some View {
        NavigationStack {
            SourcesView(viewModel, mode: .edit)
                .navigationTitle("Select Sources")
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
                    }
                }
        }
        .padding(.horizontal, Layout.Padding.regular)
        .task(id: "initial-fetch-sources") {
            await viewModel.fetchSources()
        }
    }
}

#Preview {
    OnboardingView()
}
