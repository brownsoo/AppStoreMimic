//
//  NetworkEndpoint.swift
//  AppStoreSample
//
//  Created by hyonsoo han on 2023/09/17.
//

import Foundation

protocol NetworkEndpoint {
    var urlString: String { get }
    var headers: [String: String] { get }
    var parameters: [String: Any]? { get }
}
