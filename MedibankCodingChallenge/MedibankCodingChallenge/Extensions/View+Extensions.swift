//
//  View+Extensions.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import SwiftUI

extension View {
    /// Modifies view to be presented as a placeholder, disabling intended interactions in the process.
    ///
    /// Typically used for skeleton views.
    /// - Parameter reason: `Bool` value whether to apply `.placeholder` redaction.
    /// - Returns: Conditionally redacted view.
    func asPlaceholder(reason: Bool) -> some View {
        return self
            .redacted(reason: reason ? .placeholder : [])
            .disabled(reason)
    }
    
    /// Modifier to display a `ContentUnavailableView` given the condition is fulfilled.
    /// - Parameters:
    ///   - type: The type of empty content view to display.
    ///   - condition: The condition to display the view.
    ///   - label: `Label` that makes up the main title of the view.
    ///   - description: Optional. The description displayed as a configured view.
    ///   - actions: Optional. Actions to display along the view.
    /// - Returns: Modified view with unavailable view option.
    func emptyView<Label, Description, Actions>(
        if condition: Bool,
        type: EmptyViewType = .generic,
        label: Label,
        @ViewBuilder description: () -> Description = EmptyView.init,
        @ViewBuilder actions: () -> Actions = EmptyView.init
    ) -> some View where Label : View, Description: View, Actions : View  {
        return modifier(EmptyViewModifier(for: type,
                                          if: condition,
                                          label: label,
                                          description: description,
                                          actions: actions))
    }
    
    /// Modifier to display a `ContentUnavailableView` specific for search-related activities, given the condition is fulfilled.
    /// - Parameters:
    ///   - condition: The condition to display the view.
    ///   - query: The search query.
    /// - Returns: Modified view with unavailable view option.
    func emptySearchView(if condition: Bool, query: String? = nil) -> some View {
        return modifier(EmptyViewModifier(for: .search(query),
                                          if: condition,
                                          label: EmptyView(),
                                          description: { EmptyView() },
                                          actions: { EmptyView()}))
    }
    
    @ViewBuilder
    func searchable(
        if condition: Bool,
        text: Binding<String>,
        placement: SearchFieldPlacement = .automatic,
        prompt: String = "Search"
    ) -> some View {
        if condition {
            self.searchable(text: text, placement: placement, prompt: prompt)
        } else {
            self
        }
    }
}

