//
//  ResResults.swift
//  AppStoreMimic
//
//  Created by hyonsoo on 2023/09/17.
//

import Foundation

struct ResResults<T: ResSearchResult>: Decodable {
    let resultCount: Int
    let results: [T]
}

protocol ResSearchResult: Decodable {
    /// movie, podcast, music, musicVideo, audiobook, shortFilm, tvShow, software, ebook, all
    var wrapperType: String { get }
}

