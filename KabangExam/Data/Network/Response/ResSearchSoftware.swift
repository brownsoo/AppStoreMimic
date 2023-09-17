//
//  ResSearchSoftwareResult.swift
//  KabangExam
//
//  Created by hyonsoo on 2023/09/17.
//

import Foundation

struct ResSearchSoftware: ResSearchResult {
    let artistId: Int
    /// ex) KakaoBank Corp.
    let artistName: String
    let artworkUrl512: String
    let artworkUrl100: String?
    let artworkUrl60: String?
    let averageUserRating: Double
    let averageUserRatingForCurrentVersion: Double
    let bundleId: String
    /// 이용연령 - "12+"
    let contentAdvisoryRating: String
    /// USD
    let currency: String
    let description: String
    let genres: [String]
    let kind: String
    let formattedPrice: String
    let ipadScreenshotUrls: [String]
    let isGameCenterEnabled: Bool
    let price: Double
    let primaryGenreName: String
    /// "2017-07-26T15:24:27Z"
    let releaseDate: Date
    let releaseNotes: String?
    let screenshotUrls: [String]
    let sellerName: String
    let sellerUrl: String
    /// title
    let trackName: String
    let trackViewUrl: String
    let userRatingCount: Int
    let userRatingCountForCurrentVersion: Int
    let version: String
    let wrapperType: String
    
}

extension ResSearchSoftware {
    func toDomain() -> Software {
        return .init(id: bundleId,
                     icon: URL(string: artworkUrl512),
                     title: trackName,
                     subtitle: artistName,
                     description: description,
                     screenshots: screenshotUrls.compactMap({ URL(string: $0) }),
                     rating: averageUserRatingForCurrentVersion,
                     ratingCount: userRatingCountForCurrentVersion,
                     contentAdvisoryRating: contentAdvisoryRating,
                     genre: genres.first ?? "",
                     releaseNote: releaseNotes)
    }
}

extension ResResults<ResSearchSoftware> {
    func toDomain() -> [Software] {
        return self.results.map { $0.toDomain() }
    }
}
