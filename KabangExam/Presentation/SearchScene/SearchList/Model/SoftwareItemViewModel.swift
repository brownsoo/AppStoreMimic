//
//  SoftwareItemViewModel.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/09/18.
//

import Foundation

// FIXME: Software 이름 괜찮..?
final class SoftwareItemViewModel: ResultItemModel {
    let id: String
    let iconUrl: URL?
    let title: String
    let userRating: Double
    let userRatingCount: String
    let genre: String
    let contentAdvisoryRating: String
    let screenshots: [URL]
    
    init(id: String,
         iconUrl: URL?, title: String, userRating: Double, userRatingCount: String,
         genre: String, contentAdvisoryRating: String, screenshots: [URL]) {
        self.id = id
        self.iconUrl = iconUrl
        self.title = title
        self.userRating = userRating
        self.userRatingCount = userRatingCount
        self.genre = genre
        self.contentAdvisoryRating = contentAdvisoryRating
        self.screenshots = screenshots
    }
}

extension SoftwareItemViewModel {
    convenience init(model: Software) {
        self.init(
            id: model.id,
            iconUrl: model.icon,
            title: model.title,
            userRating: model.rating,
            userRatingCount: model.ratingCount.readableCount(),
            genre: model.genre,
            contentAdvisoryRating: model.contentAdvisoryRating,
            screenshots: model.screenshots
        )
    }
}
