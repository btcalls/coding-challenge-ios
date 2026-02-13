//
//  HeadlinesListView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 13/2/2026.
//

import SwiftUI
import Combine

struct HeadlinesListView: View {
    @ObservedObject var viewModel: HeadlinesViewModel
    @StateObject var searchContext: SearchContext
    
    @Environment(\.isSearching) private var isSearching
    
    private var emptyViewInfo: AttributedString {
        let word = TabKey.sources.rawValue
        let string = "Head to the \(word) tab to select article sources."
        
        return string.highlight(word)
    }
    
    /// Flag whether data fetched from API is empty.
    private var isResultEmpty: Bool {
        if viewModel.isLoading {
            return false
        }
        
        return !isSearching && (
            viewModel.errorMessage != nil || viewModel.data.isEmpty
        )
    }
    /// Flag whether data fetched from API due to a search query is empty.
    private var isSearchEmpty: Bool {
        if viewModel.isLoading {
            return false
        }
        
        return (isSearching && !searchContext.debouncedQuery.isEmpty) && (
            viewModel.errorMessage != nil || viewModel.data.isEmpty
        )
    }
    
    var body: some View {
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
        }
        .emptyView(
            if: isResultEmpty,
            label: Label("No Articles", systemImage: "newspaper"),
            description: {
                VStack {
                    Text("Articles from selected sources will appear here.")
                    Text(emptyViewInfo)
                }
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
        .emptySearchView(
            if: isSearchEmpty,
            query: searchContext.debouncedQuery
        )
        .onChange(of: isSearching) { oldValue, newValue in
            // Dismissed the search bar
            if oldValue && !newValue {
                Task(name: "fetch-articles-after-dismiss-search") {
                    await viewModel.fetchArticles()
                }
            }
        }
    }
}

#Preview {
    HeadlinesView()
}
