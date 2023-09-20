//
//  SearchFlowCoordinator.swift
//  AppStoreSample
//
//  Created by hyonsoo on 2023/09/19.
//

import UIKit

protocol SearchFlowCoordinatorDependencies {
    func makeSearchView(actions: SearchListViewActions) -> UIViewController
    func makeDetailView(data: Software) -> UIViewController
}

final class SearchFlowCoordinator: FlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: SearchFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController? = nil,
         dependencies: SearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = SearchListViewActions(showSoftwareDetail: self.showDetails)
        let vc = dependencies.makeSearchView(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
    }
    
}

extension SearchFlowCoordinator {
    private func showDetails(data: Software) {
        let vc = dependencies.makeDetailView(data: data)
        navigationController?.pushViewController(vc, animated: true)
    }
}


