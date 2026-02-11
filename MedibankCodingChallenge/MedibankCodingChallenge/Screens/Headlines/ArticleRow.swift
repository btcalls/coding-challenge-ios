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
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(article.title)
                    .articleTitleStyle()
                Text("By \(article.author)")
                    .secondaryTextStyle()
                Text(article.articleDescription)
                    .descriptionStyle()
                    .lineLimit(2, reservesSpace: true)
            }
            
            CustomImage(url: article.thumbnail, thumbnailMaxDimension: size)
                .frame(width: size, height: size)
                .clipShape(.rect(cornerRadius: Layout.CornerRadius.regular))
        }
        .padding(.all, Layout.Padding.regular)
    }
}

#Preview {
    ArticleRow(article: MockValues.article)
}
