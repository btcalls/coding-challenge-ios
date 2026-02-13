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
                .navigationTitle("All Articles")
                .navigationSubtitle(Text(viewModel.fetchInfo))
                .refreshable {
                    await viewModel.fetchArticles()
                }
                .searchable(
                    text: $searchContext.query,
                    placement: .navigationBarDrawer(displayMode: .automatic)
                )
                .scrollDisabled(viewModel.data.isEmpty)
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
