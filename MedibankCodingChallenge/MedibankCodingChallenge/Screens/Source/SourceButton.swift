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
    
    @Environment(\.isEnabled) private var isEnabled
    
    @ViewBuilder
    private var label: some View {
        HStack(alignment: .center, spacing: Layout.Spacing.md) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .opacity(isEnabled ? 1 : 0)
                .animation(.spring, value: isEnabled)
                         
            Text(title)
        }
        .fontWeight(isSelected ? .medium : .regular)
    }
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
        }, label: {
            label
        })
        .buttonStyle(ToggleButtonStyle(isSelected: isSelected))
    }
}

#Preview {
    @Previewable @State var source = MockValues.source
    @Previewable @State var isEnabled = false
    
    Toggle(isOn: $isEnabled) {
        Text("Enable Button")
    }
    
    SourceButton(title: source.name, isSelected: Binding<Bool>(
        get: { source.isSelected },
        set: { source.isSelected = $0 }
    ))
    .frame(width: 250, height: 80)
    .disabled(!isEnabled)
}

