//
//  AppDIProvider.swift
//  AppStoreSample
//
//  Created by hyonsoo han on 2023/09/20.
//

import Foundation

@MainActor
final class AppDIProvider {
    // 앱에서 범용으로 사용하는 네트워크 데이터 제공 서비스
    // 앱에서 하나의 인스턴스만 유지하
    lazy var networkDataService: NetworkDataService = {
        DefaultNetworkDataService(client: AlamofireNetworkClient(),
                                  decoder: JSONResponseDecoder())
    }()
    
    func makeSearchSceneDIProvider() -> SearchSceneDIProvider {
        SearchSceneDIProvider(networkDataService: self.networkDataService)
    }
}
