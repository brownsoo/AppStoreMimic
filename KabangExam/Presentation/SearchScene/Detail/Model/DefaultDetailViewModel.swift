//
//  DefaultDetailViewModel.swift
//  KabangExam
//
//  Created by hyonsoo on 2023/09/20.
//

import Foundation
import Combine

final class DefaultDetailViewModel: BaseViewModel, DetailViewModel {
    
    // DetailViewModel ->
    var iconUrl: URL?
    var title: String
    var subtitle: String
    var userRating: Double
    var userRatingCount: String
    var genre: String
    var contentAdvisoryRating: String
    var screenshots: [URL]
    var description: String
    var version: String
    var releaseNote: String?
    var seller: String
    
    // <--
    
    init(_ data: Software) {
        iconUrl = data.bigIcon
        title = data.title
        subtitle = data.subtitle
        userRating = data.rating
        userRatingCount = data.ratingCount.readableCount()
        genre = data.genre
        contentAdvisoryRating = data.contentAdvisoryRating
        screenshots = data.screenshots
        description = data.description
        version = data.version
        releaseNote = data.releaseNote
        seller = data.sellerName
    }
}
