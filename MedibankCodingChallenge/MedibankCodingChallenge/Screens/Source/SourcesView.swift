//
//  SourcesView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import SwiftUI
import Combine

/// Child view used to fetch and display `[Source]` instances.
struct SourcesView<Actions>: View where Actions: View {
    enum Mode {
        case view
        case edit
    }
    
    var mode: Mode = .edit
    var additionalInfo: String? = nil
    @ViewBuilder var actions: Actions
    
    @ObservedObject private var viewModel: SourcesViewModel
    
    var body: some View {
        ScrollView {
            if let additionalInfo {
                Text(additionalInfo)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .subHeaderStyle()
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
        .safeAreaBar(edge: .bottom, spacing: Layout.Padding.comfortable) {
            if viewModel.selectedCount > 0  {
                Text("\(viewModel.selectedCount) selected")
                    .padding(.all, Layout.Padding.regular)
                    .glassEffect(.regular, in: .capsule)
                    .padding(.bottom, Layout.Padding.regular)
                    .animation(.easeInOut, value: viewModel.selectedCount)
            }
        }
    }
}

extension SourcesView {
    init(_ viewModel: SourcesViewModel,
         mode: Mode = .edit,
         additionalInfo: String? = nil,
         @ViewBuilder emptyViewActions actions: () -> Actions = EmptyView.init) {
        self.viewModel = viewModel
        self.mode = mode
        self.additionalInfo = additionalInfo
        self.actions = actions()
    }
}

#Preview {
    @Previewable @StateObject var viewModel = SourcesViewModel(
        container: MockSwiftDataManager().container
    )
    
    SourcesView(viewModel, mode: .view, additionalInfo: "Hey!!")
}
