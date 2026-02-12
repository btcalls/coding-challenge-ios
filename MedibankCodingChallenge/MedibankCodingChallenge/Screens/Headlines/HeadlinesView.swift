//
//  HeadlinesView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import SwiftUI
import WebKit

struct HeadlinesView: View {
    @StateObject private var viewModel = HeadlinesViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.data, id: \.url) { article in
                LazyVStack(spacing: Layout.Spacing.regular) {
                    NavigationLink(value: article) {
                        ArticleRow(article: article)
                            .asPlaceholder(reason: viewModel.isLoading)
                    }
                    .swipeActions {
                        Button {
                            viewModel.save(article: article)
                        } label: {
                            Label("Save", systemImage: "bookmark")
                        }
                        .tint(.yellow)
                    }
                }
                .padding(.top, Layout.Padding.comfortable)
            }
            .navigationDestination(for: Article.self) {
                WebView(url: $0.url)
                    .webViewBackForwardNavigationGestures(.disabled)
            }
            .navigationTitle("Latest News")
            .navigationSubtitle(viewModel.fetchInfo)
            .emptyView(
                if: viewModel.errorMessage != nil || viewModel.data.isEmpty,
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
            .refreshable {
                await viewModel.fetchArticles()
            }
        }
        .task(id: "initial-load-articles") {
            await viewModel.fetchArticlesIfNeeded()
        }
    }
}

#Preview {
    HeadlinesView()
}
