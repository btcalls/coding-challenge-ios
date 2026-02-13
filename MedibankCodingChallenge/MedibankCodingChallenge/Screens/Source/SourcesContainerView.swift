//
//  SourcesContainerView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import SwiftUI

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
            Button(isEditing ? "Save" : "Select") {
                if isEditing {
                    try? viewModel.saveSelectedSources()
                }
                
                isEditing.toggle()
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            SourcesView(viewModel: viewModel)
                .disabled(!isEditing)
                .navigationTitle("Article Sources")
                .padding(.top, Layout.Padding.comfortable)
                .padding(.horizontal, Layout.Padding.regular)
                .toolbar {
                    toolbarContent
                }
        }
        .task(id: "initial-load-sources-from-storage") {
            await viewModel.fetchSources()
        }
    }
}

#Preview {
    SourcesContainerView()
}
