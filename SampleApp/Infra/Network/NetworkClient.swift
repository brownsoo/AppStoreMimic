//
//  NetworkClient.swift
//  AppStoreSample
//
//  Created by hyonsoo on 10/23/23.
//  Copyright © 2023 HSL. All rights reserved.
//

import Foundation

protocol NetworkClient {
    func request(_ resource: some NetworkRequest) async throws -> NetworkResponse
}
