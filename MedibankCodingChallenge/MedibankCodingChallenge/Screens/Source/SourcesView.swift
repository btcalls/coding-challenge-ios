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
    enum Mode {
        case view
        case edit
    }
    
    @ObservedObject private var viewModel: SourcesViewModel
    
    var mode: Mode
    
    init(viewModel: SourcesViewModel, mode: Mode = .edit) {
        self.viewModel = viewModel
        self.mode = mode
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
                    .asPlaceholder(reason: viewModel.isLoading)
                    .disabled(mode == .view)
                }
            }
            .padding(.top, Layout.Padding.comfortable)
        }
        .safeAreaBar(edge: .bottom, spacing: Layout.Spacing.regular) {
            if viewModel.selectedCount > 0  {
                Text("\(viewModel.selectedCount) selected")
                    .padding(.all, Layout.Padding.regular)
                    .glassEffect(.regular, in: .capsule)
                    .animation(.easeInOut, value: viewModel.selectedCount)
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel = SourcesViewModel()
    
    SourcesView(viewModel: viewModel, mode: .view)
}
