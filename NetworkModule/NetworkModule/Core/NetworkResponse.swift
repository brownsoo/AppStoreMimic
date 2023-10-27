//
//  NetworkResponse.swift
//  NetworkModule
//
//  Created by hyonsoo han on 2023/09/17.
//

import Foundation

public protocol NetworkResponse {
    var status: Int { get }
    var data: Data? { get }
}
