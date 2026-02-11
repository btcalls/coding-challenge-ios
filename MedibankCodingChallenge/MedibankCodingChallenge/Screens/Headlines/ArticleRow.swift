//
//  ArticleRow.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import SwiftUI

struct ArticleRow: View {
    private let size: CGFloat = 120
    
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: Layout.Spacing.regular) {
                VStack(alignment: .leading) {
                    Text(article.title)
                        .articleTitleStyle()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let author = article.author {
                        Text(author)
                            .secondaryTextStyle()
                    }
                }
                
                CustomImage(
                    url: article.thumbnail,
                    thumbnailMaxDimension: Layout.Size.thumbnailMax
                )
                .frame(width: size, height: size)
                .clipShape(.rect(
                    cornerRadius: Layout.CornerRadius.regular,
                    style: .continuous
                ))
            }
            
            Text(article.articleDescription)
                .descriptionStyle()
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
        }
    }
}

#Preview {
    ArticleRow(article: MockValues.article)
}
