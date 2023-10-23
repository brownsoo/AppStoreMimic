//
//  ApiResponse.swift
//  AppStoreSample
//
//  Created by hyonsoo han on 2023/09/17.
//

import Foundation

struct ApiResponse: NetworkResponse {
    var status: Int
    var data: Data?
}
