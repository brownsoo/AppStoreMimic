//
//  AppFlowCoordinator.swift
//  AppStoreSample
//
//  Created by hyonsoo han on 2023/09/20.
//

import UIKit

// 앱 단에서 화면 그룹(씬) 단위의 화면 흐름 제공
@MainActor
final class AppFlowCoordinator {
    private(set) var navigationController: UINavigationController
    private let diProvider: AppDIProvider
    
    init(navigationController: UINavigationController, diProvider: AppDIProvider) {
        self.navigationController = navigationController
        self.diProvider = diProvider
    }
    
    
}

extension AppFlowCoordinator: FlowCoordinator {
    func start() {
        let provider = diProvider.makeSearchSceneDIProvider()
        let flow = provider.makeSearchFlowCoordinator(nc: navigationController)
        flow.start()
    }
}
