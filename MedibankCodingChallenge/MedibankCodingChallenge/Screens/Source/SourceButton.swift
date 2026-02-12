//
//  SourceButton.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import SwiftUI

struct SourceButton: View {
    var title: String
    @Binding var isSelected: Bool
    
    @ViewBuilder
    private var label: some View {
        HStack(alignment: .center, spacing: Layout.Spacing.md) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
            Text(title)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .padding(.all, Layout.Padding.comfortable)
        .fontWeight(isSelected ? .medium : .regular)
    }
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
        }, label: {
            label
        })
        .background(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
        .tint(.primary)
        .clipShape(
            .rect(cornerRadius: Layout.CornerRadius.regular, style: .continuous)
        )
    }
}

#Preview {
    @Previewable @State var text: String = "Not selected"
    @Previewable @State var source = MockValues.source
    
    SourceButton(title: source.name, isSelected: Binding<Bool>(
        get: { source.isSelected },
        set: { source.isSelected = $0 }
    ))
    .frame(width: 250, height: 80)
}

