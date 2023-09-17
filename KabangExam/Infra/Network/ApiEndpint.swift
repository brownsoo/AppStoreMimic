//
//  ApiEndpint.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/08/31.
//

import Foundation

protocol ApiEndpoint {
    var urlString: String { get }
    var headers: [String: String] { get }
    var parameters: [String: Any]? { get }
}
