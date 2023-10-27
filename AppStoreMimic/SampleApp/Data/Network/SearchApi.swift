//
//  SearchApi.swift
//  AppStoreMimic
//
//  Created by hyonsoo on 2023/09/17.
//

import Foundation
import NetworkModule

struct SearchApi {
    static func search(_ term: String, limit: Int = 10) -> ApiRequest<ResResults<ResSearchSoftware>> {
        var encoded = term.replacingOccurrences(of: " ", with: "+")
        encoded = encoded.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? encoded
        return ApiRequest(
            iTunesSearchEndpoint("/search", parameters: [
                "term": encoded,
                "country": "KR",
                "media": "software"
            ])
        )
    }
}
