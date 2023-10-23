//
//  ResponseDecoder.swift
//  AppStoreSample
//
//  Created by hyonsoo han on 2023/09/17.
//

import Foundation

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

