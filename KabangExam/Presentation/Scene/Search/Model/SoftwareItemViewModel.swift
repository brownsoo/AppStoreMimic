//
//  SoftwareItemViewModel.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/09/18.
//

import Foundation

struct SoftwareItemViewModel {
    let iconUrl: URL?
    let title: String
    let userRating: Double
    let userRatingCount: String
    let genre: String
    let contentAdvisoryRating: String
    let screenshots: [URL]
    
    init(iconUrl: URL?, title: String, userRating: Double, userRatingCount: String, genre: String, contentAdvisoryRating: String, screenshots: [URL]) {
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
    init(model: Software) {
        self.iconUrl = model.icon
        self.title = model.title
        self.userRating = model.rating
        self.userRatingCount = model.ratingCount.readableCount()
        self.genre = model.genre
        self.contentAdvisoryRating = model.contentAdvisoryRating
        self.screenshots = model.screenshots
    }
}
