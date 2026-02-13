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
    @StateObject private var searchContext = SearchContext()
    
    var body: some View {
        NavigationStack {
            HeadlinesListView(viewModel: viewModel, searchContext: searchContext)
                .navigationDestination(for: Article.self) {
                    WebView(url: $0.url)
                        .webViewBackForwardNavigationGestures(.disabled)
                }
                .navigationTitle("Latest News")
                .navigationSubtitle(viewModel.fetchInfo)
                .refreshable {
                    await viewModel.fetchArticles()
                }
                .searchable(
                    if: viewModel.hasSources,
                    text: $searchContext.query,
                    placement: .navigationBarDrawer(displayMode: .always)
                )
                .autocorrectionDisabled()
                .onChange(of: searchContext.debouncedQuery) { oldValue, newValue in
                    guard oldValue != newValue else {
                        return
                    }
                    
                    Task(name: "fetch-articles-with-query") {
                        await viewModel.fetchArticles(withQuery: newValue)
                    }
                }
        }
        .task(id: "initial-fetch-articles") {
            await viewModel.fetchArticlesIfNeeded()
        }
    }
}

#Preview {
    HeadlinesView()
}
