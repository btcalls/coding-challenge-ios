//
//  ToggleButtonStyle.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 13/2/2026.
//

import SwiftUI

/// Button style to apply toggle-like behaviour.
struct ToggleButtonStyle: ButtonStyle {
    var isSelected: Bool
    
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.vertical, Layout.Padding.comfortable)
            .padding(.horizontal, Layout.Padding.regular)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .foregroundStyle(.primary)
            .background(
                RoundedRectangle(
                    cornerRadius: Layout.CornerRadius.regular,
                    style: .continuous
                )
                .fill(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
            )
    }
}
