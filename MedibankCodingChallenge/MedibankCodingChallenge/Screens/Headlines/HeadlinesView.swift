//
//  HeadlinesView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import SwiftUI

struct HeadlinesView: View {
    @StateObject private var viewModel = HeadlinesViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.data) { article in
                LazyVStack(spacing: Layout.Spacing.regular) {
                    ArticleRow(article: article)
                        .redacted(reason: viewModel.isLoading ? .placeholder : [])
                }
            }
            .emptyView(
                if: viewModel.errorMessage != nil && viewModel.data.count == 0,
                label: Label("No Articles", systemImage: "newspaper"),
                description: {
                    Text("Articles from selected sources will appear here.")
                },
                actions: {
                    Button(action: {
                        Task {
                            await viewModel.fetchArticles()
                        }
                    }, label: {
                        Text("Get Articles")
                            .fontWeight(.medium)
                            .padding(.all, Layout.Padding.compact)
                    })
                    .buttonStyle(.glassProminent)
                }
            )
            .navigationTitle("Your News")
            .task {
                await viewModel.fetchArticles()
            }
            .refreshable {
                await viewModel.fetchArticles()
            }
        }
    }
}

#Preview {
    HeadlinesView()
}
