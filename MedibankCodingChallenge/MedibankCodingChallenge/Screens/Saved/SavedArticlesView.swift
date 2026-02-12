//
//  SavedArticlesView.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import SwiftUI

struct SavedArticlesView: View {
    var body: some View {
        List {
        }
        .emptyView(
            if: true,
            label: Label("No Saved Articles", systemImage: "bookmark.fill"),
            description: {
                Text("Saved articles will appear here.")
            },
            actions: {
                Button(action: {
                    // TODO: Switch to Headlines tab
                }, label: {
                    Text("Check Headlines")
                        .fontWeight(.medium)
                        .padding(.all, Layout.Padding.compact)
                })
                .buttonStyle(.glassProminent)
            }
        )
    }
}

#Preview {
    SavedArticlesView()
}
