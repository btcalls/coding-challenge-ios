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
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: Layout.Spacing.regular) {
                VStack(alignment: .leading) {
                    Text(article.title)
                        .articleTitleStyle()
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .topLeading
                        )
                    
                    if let author = article.author {
                        Text(author)
                            .secondaryTextStyle()
                    }
                }
                
                CustomImage(
                    url: article.thumbnail,
                    thumbnailMaxDimension: Layout.Size.thumbnailMax
                )
                .frame(width: Layout.Size.thumbnail, height: Layout.Size.thumbnail)
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
