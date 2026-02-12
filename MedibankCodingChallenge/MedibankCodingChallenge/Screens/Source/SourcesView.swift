//
//  SourcesView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import SwiftUI
import Combine

struct SourcesView<Actions>: View where Actions: View {
    enum Mode {
        case view
        case edit
    }
    
    @ObservedObject private var viewModel: SourcesViewModel
    
    
    var mode: Mode = .edit
    @ViewBuilder var actions: Actions
    
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
        .emptyView(
            if: viewModel.errorMessage != nil || viewModel.data.isEmpty,
            label: Label("No Sources", systemImage: "network"),
            description: {
                VStack {
                    Text("All article sources will appear here.")
                }
            },
            actions: { actions }
        )
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

extension SourcesView {
    init(_ viewModel: SourcesViewModel,
         mode: Mode = .edit,
         @ViewBuilder actions: () -> Actions = EmptyView.init) {
        self.viewModel = viewModel
        self.mode = mode
        self.actions = actions()
    }
}

#Preview {
    @Previewable @StateObject var viewModel = SourcesViewModel()
    
    SourcesView(viewModel, mode: .view)
}
