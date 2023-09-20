//
//  SearchSceneDIProvider.swift
//  AppStoreSample
//
//  Created by hyonsoo on 2023/09/20.
//

import UIKit

@MainActor
final class SearchSceneDIProvider {
    private let networkDataService: NetworkDataService
    private lazy var recentsStore: RecentsStorage = DefaultRecentsStorage()
    
    init(networkDataService: NetworkDataService) {
        self.networkDataService = networkDataService
    }
    
    func makeRepository() -> iTunesRepository {
        DefaultRepository(dataService: self.networkDataService,
                          recentsCache: self.recentsStore)
    }
    
    func makeSearchListViewModel(actions: SearchListViewActions) -> SearchViewModel {
        DefaultSearchViewModel(repository: self.makeRepository(), actions: actions)
    }
    
    func makeDetailViewModel(data: Software) -> DetailViewModel {
        DefaultDetailViewModel(data)
    }
    
    func makeSearchFlowCoordinator(nc: UINavigationController) -> SearchFlowCoordinator {
        SearchFlowCoordinator(navigationController: nc, dependencies: self)
    }
}

extension SearchSceneDIProvider: SearchFlowCoordinatorDependencies {
    func makeSearchView(actions: SearchListViewActions) -> UIViewController {
        SearchListViewController.create(
            viewModel: self.makeSearchListViewModel(actions: actions))
    }
    
    func makeDetailView(data: Software) -> UIViewController {
        DetailViewController.create(viewModel: self.makeDetailViewModel(data: data))
    }
}
