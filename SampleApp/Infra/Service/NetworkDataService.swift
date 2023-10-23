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
    func request<T>(_ request: some NetworkRequest<T>) async throws -> T where T: Decodable
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
    func request<T>(_ request: some NetworkRequest<T>) async throws -> T where T: Decodable {
        let res = try await self.client.request(request)
        if res.status == 304 {
            // 304 를 오류로 처리
            throw NetworkError.contentNotChanged
        }
        guard let data = res.data else {
            // FIXME: 바디가 없지만 성공한 응답문 처리
            throw NetworkError.emptyResponse
        }
        let model: T = try self.decoder.decode(data)
        return model
    }
}
