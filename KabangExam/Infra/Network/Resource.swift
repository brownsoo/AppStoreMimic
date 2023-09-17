//
//  Resource.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/09/17.
//

import Foundation

protocol Resource {
    var url: URL { get }
    var headers: [String : String] { get }
    
    func toUrlRequest() throws -> URLRequest
}
