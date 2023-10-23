//
//  NetworkResponse.swift
//  AppStoreSample
//
//  Created by hyonsoo han on 2023/09/17.
//

import Foundation

protocol NetworkResponse {
    var status: Int { get }
    var data: Data? { get }
}
