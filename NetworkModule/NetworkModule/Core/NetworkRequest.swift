//
//  NetworkRequest.swift
//  NetworkModule
//
//  Created by hyonsoo han on 2023/09/17.
//

import Foundation

public protocol NetworkRequest<ResponseType> {
    associatedtype ResponseType
    var url: URL { get }
    var headers: [String : String] { get }
    
    func toUrlRequest() throws -> URLRequest
}
