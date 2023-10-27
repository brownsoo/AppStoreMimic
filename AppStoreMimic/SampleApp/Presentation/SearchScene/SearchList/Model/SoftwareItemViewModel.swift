//
//  SoftwareItemViewModel.swift
//  AppStoreMimic
//
//  Created by hyonsoo han on 2023/09/18.
//

import Foundation

// FIXME: Software 이름 괜찮..?
final class SoftwareItemViewModel: ResultItemModel {
    let id: String
    let iconUrl: URL?
    let title: String
    let subtitle: String
    let userRating: Double
    let userRatingCount: String
    let genre: String
    let contentAdvisoryRating: String
    let screenshots: [URL]
    let sellerName: String
    
    init(id: String,
         iconUrl: URL?, title: String,
         subtitle: String,
         userRating: Double, userRatingCount: String,
         genre: String, contentAdvisoryRating: String, screenshots: [URL],
         sellerName: String
    ) {
        self.id = id
        self.iconUrl = iconUrl
        self.title = title
        self.subtitle = subtitle
        self.userRating = userRating
        self.userRatingCount = userRatingCount
        self.genre = genre
        self.contentAdvisoryRating = contentAdvisoryRating
        self.screenshots = screenshots
        self.sellerName = sellerName
    }
}

extension SoftwareItemViewModel {
    convenience init(model: Software) {
        self.init(
            id: model.id,
            iconUrl: model.icon,
            title: model.title,
            subtitle: model.subtitle,
            userRating: model.rating,
            userRatingCount: model.ratingCount.readableCount(),
            genre: model.genre,
            contentAdvisoryRating: model.contentAdvisoryRating,
            screenshots: model.screenshots,
            sellerName: model.sellerName
        )
    }
}
