//
//  SearchApi.swift
//  AppStoreSample
//
//  Created by hyonsoo on 2023/09/17.
//

import Foundation

struct SearchApi {
    static func search(_ term: String, limit: Int = 10) -> NetworkResource<ResResults<ResSearchSoftware>> {
        var encoded = term.replacingOccurrences(of: " ", with: "+")
        encoded = encoded.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? encoded
        return NetworkResource(
            iTunesSearchEndpoint("/search", parameters: [
                "term": encoded,
                "country": "KR",
                "media": "software"
            ])
        )
    }
}
