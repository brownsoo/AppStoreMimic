//
//  DetailViewModel.swift
//  KabangExam
//
//  Created by hyonsoo on 2023/09/20.
//

import Foundation
import Combine

protocol DetailViewModel: ViewModel {
    // -- out
    var iconUrl: URL? { get }
    var title: String { get }
    var subtitle: String { get }
    var userRating: Double { get }
    var userRatingCount: String { get }
    var genre: String { get }
    var contentAdvisoryRating: String { get }
    var seller: String { get }
    var screenshots: [URL] { get }
    var description: String { get }
    var version: String { get }
    var releaseNote: String? { get }
}
