//
//  SourcesView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import SwiftUI
import Combine

//struct SourcesView<VM: AppViewModel>: View where VM.Value == [Source] {
struct SourcesView: View {
    @ObservedObject private var viewModel: SourcesViewModel
    
    init(viewModel: SourcesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Layout.Spacing.md) {
                ForEach(viewModel.data, id: \.id) { source in
                    SourceButton(title: source.name, isSelected: Binding<Bool>(
                        get: { source.isSelected },
                        set: { source.isSelected = $0 }
                    ))
                    .redacted(reason: viewModel.isLoading ? .placeholder : [])
                }
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel = SourcesViewModel()
    
    SourcesView(viewModel: viewModel)
}
