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
        let systemImage = isSelected ? "checkmark.circle.fill" : "circle"
        
        Label(title, systemImage: systemImage)
            .fontWeight(.medium)
            .padding(.all, Layout.Padding.comfortable)
    }
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
        }, label: {
            label
        })
        .background(isSelected ? Color.accentColor : Color.secondary)
        .tint(.primary)
        .clipShape(
            .rect(cornerRadius: Layout.CornerRadius.regular, style: .continuous)
        )
    }
}

#Preview {
    @Previewable @State var text: String = "Not selected"
    @Previewable @State var source = MockValues.source
    
    Text(source.isSelected ? "Selected" : "Not selected")
    SourceButton(title: "Test", isSelected: Binding<Bool>(
        get: { source.isSelected },
        set: { source.isSelected = $0 }
    ))
}
