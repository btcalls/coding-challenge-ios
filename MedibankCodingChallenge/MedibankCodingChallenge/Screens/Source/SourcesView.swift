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
    
    private var count: Int {
        return viewModel.data.filter { $0.isSelected }.count
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
        .safeAreaBar(edge: .bottom, spacing: Layout.Spacing.regular) {
            if count > 0  {
                Text("\(count) selected")
                    .padding(.all, Layout.Padding.regular)
                    .glassEffect(.regular, in: .capsule)
                    .animation(.easeInOut, value: count)
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel = SourcesViewModel()
    
    SourcesView(viewModel: viewModel)
}
