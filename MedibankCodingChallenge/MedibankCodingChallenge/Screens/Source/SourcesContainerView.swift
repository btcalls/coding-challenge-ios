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
    
    var body: some View {
        NavigationStack {
            SourcesView(viewModel: viewModel)
                .disabled(!isEditing)
                .navigationTitle("Article Sources")
                .padding(.top, Layout.Padding.comfortable)
                .padding(.horizontal, Layout.Padding.regular)
                .toolbar {
                    Button(isEditing ? "Save" : "Select") {
                        // Saving changes
                        if isEditing {
                            onSave()
                        }
                        
                        isEditing.toggle()
                    }
                }
        }
        .task(id: "initial-load-sources-from-storage") {
            await viewModel.fetchSources()
        }
    }
    
    private func onSave() {
        let _ = viewModel.data.filter { $0.isSelected }
        
        // TODO: Save to storage
    }
}

#Preview {
    SourcesContainerView()
}
