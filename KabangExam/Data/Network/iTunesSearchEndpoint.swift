//
//  iTunesSearchEndpoint.swift
//  KabangExam
//
//  Created by hyonsoo on 2023/09/17.
//

import Foundation

struct iTunesSearchEndpoint: ApiEndpoint {
    let apiHost = "https://itunes.apple.com/search"
    let urlString: String
    var headers: [String : String]
    var parameters: [String : Any]?
    
    init(_ path: String, parameters: [String : Any]? = nil) {
        self.urlString = "\(apiHost)\(path)"
        self.headers = [:]
        self.headers["Content-Type"] = "application/json"
        self.parameters = parameters
    }
}
