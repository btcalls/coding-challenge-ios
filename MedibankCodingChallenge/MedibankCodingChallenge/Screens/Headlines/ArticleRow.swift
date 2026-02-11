//
//  ArticleRow.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import SwiftUI

struct ArticleRow: View {
    let article: Article
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(article.title)
                    .articleTitleStyle()
                    .lineLimit(2)
                Text("By \(article.author)")
                    .secondaryTextStyle()
                Text(article.articleDescription)
                    .descriptionStyle()
                    .lineLimit(2, reservesSpace: true)
            }
        }
    }
}

#Preview {
    ArticleRow(article: MockValues.article)
}
