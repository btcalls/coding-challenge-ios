//
//  SourcesContainerView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import SwiftUI

/// Main view used for the `Sources` tab.
struct SourcesContainerView: View {
    @State private var isEditing: Bool = false
    @StateObject private var viewModel = SourcesViewModel()
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        if isEditing {
            ToolbarItem(placement: .destructiveAction) {
                Button("Clear All") {
                    viewModel.clearSelectedSources()
                }
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button(role: .close) {
                    isEditing = false
                }
            }
        }
        
        ToolbarSpacer(placement: .confirmationAction)
        
        ToolbarItem(placement: .confirmationAction) {
            if !viewModel.isLoading {
                Button(isEditing ? "Save" : "Select") {
                    if isEditing {
                        try? viewModel.saveSelectedSources()
                    }
                    
                    isEditing.toggle()
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            SourcesView(viewModel, mode: isEditing ? .edit : .view)
                .navigationTitle("Article Sources")
                .toolbar {
                    toolbarContent
                }
        }
        .padding(.horizontal, Layout.Padding.regular)
        .task(id: "initial-load-sources-from-storage") {
            await viewModel.fetchSources()
        }
    }
}

#Preview {
    SourcesContainerView()
}
