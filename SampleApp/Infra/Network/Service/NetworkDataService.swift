//
//  NetworkDataService.swift
//  AppStoreSample
//
//  Created by hyonsoo han on 2023/09/17.
//

import Foundation

/// 네트워크에서 데이터 모델을 제공
protocol NetworkDataService {
    /// 원격 리소스에 요청하고 데이터를 받는다.
    func request<T>(_ resource: NetworkResource<T>) async throws -> T where T: Decodable
}

final class DefaultNetworkDataService {
    private let client: NetworkClient
    private let decoder: ResponseDecoder
    
    init(client: NetworkClient,
         decoder: ResponseDecoder) {
        self.client = client
        self.decoder = decoder
    }
}

extension DefaultNetworkDataService: NetworkDataService {
    func request<T>(_ resource: NetworkResource<T>) async throws -> T where T: Decodable {
        let res = try await self.client.request(resource)
        if res.status == 304 {
            throw AppError.contentNotChanged
        }
        guard let data = res.data else {
            throw AppError.emptyResponse
        }
        let model: T = try self.decoder.decode(data)
        return model
    }
}
