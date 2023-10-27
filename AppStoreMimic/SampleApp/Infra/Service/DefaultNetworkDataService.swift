//
//  NetworkDataService.swift
//  AppStoreMimic
//
//  Created by hyonsoo han on 2023/09/17.
//

import Foundation
import NetworkModule

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
        let model: T = try self.decoder.decode(res.data)
        return model
    }
}
