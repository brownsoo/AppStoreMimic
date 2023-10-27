//
//  NetworkClient.swift
//  NetworkModule
//
//  Created by hyonsoo on 10/23/23.
//

import Foundation

public protocol NetworkClient {
    func request(_ resource: some NetworkRequest) async throws -> NetworkResponse
}
