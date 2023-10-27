//
//  ResponseDecoder.swift
//  NetworkModule
//
//  Created by hyonsoo han on 2023/09/17.
//

import Foundation

public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data?) throws -> T
}

