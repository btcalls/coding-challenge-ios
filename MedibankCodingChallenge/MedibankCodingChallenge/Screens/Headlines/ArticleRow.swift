//
//  ArticleRow.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import SwiftUI

struct ArticleRow: View {
    let article: Article
    
    @ViewBuilder private var authorText: some View {
        if let author = article.author {
            let string = "\(author) of \(article.source.name)".highlight(author)
            
            Text(string)
        } else {
            Text(article.source.name)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: Layout.Spacing.regular) {
                VStack(alignment: .leading, spacing: Layout.Spacing.md) {
                    Text(article.title)
                        .articleTitleStyle()
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .topLeading
                        )
                    
                    authorText
                        .secondaryTextStyle()
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
