//
//  NetworkResponse.swift
//  AppStoreSample
//
//  Created by hyonsoo han on 2023/09/17.
//

import Foundation

struct NetworkResponse: Response {
    var status: Int
    var data: Data?
}
