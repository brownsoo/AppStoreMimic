//
//  NetworkDataService.swift
//  NetworkModule
//
//  Created by hyonsoo on 10/27/23.
//

import Foundation

/// 네트워크에서 데이터 모델을 제공
public protocol NetworkDataService {
    /// 원격 리소스에 요청하고 데이터를 받는다.
    func request<T>(_ request: some NetworkRequest<T>) async throws -> T where T: Decodable
}
