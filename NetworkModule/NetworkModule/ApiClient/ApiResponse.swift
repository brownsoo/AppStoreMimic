//
//  ApiResponse.swift
//  NetworkModule
//
//  Created by hyonsoo on 10/27/23.
//

import Foundation

public struct ApiResponse: NetworkResponse {
    public var status: Int
    public var data: Data?
}
