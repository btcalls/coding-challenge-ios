//
//  SourcesView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import SwiftUI

struct SourcesView: View {
    @StateObject private var viewModel = SourcesViewModel()
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView().progressViewStyle(.circular)
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Layout.Spacing.md) {
                ForEach(viewModel.data, id: \.id) { source in
                    SourceButton(title: source.name, isSelected: Binding<Bool>(
                        get: { source.isSelected },
                        set: { source.isSelected = $0 }
                    ))
                }
            }
        }
        .task(id: "initial-load-sources") {
            await viewModel.fetchSources()
        }
    }
}

#Preview {
    SourcesView()
}
