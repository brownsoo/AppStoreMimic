//
//  DefaultSearchViewModel.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/09/19.
//

import Foundation
import Combine

/// default SearchViewModel implements

final class DefaultSearchViewModel: BaseViewModel {
    private let repository: iTunesRepository
    private let _stateChanges: CurrentValueSubject<SearchViewState, Never>
    
    init(repository: iTunesRepository) {
        self.repository = repository
        self._stateChanges = CurrentValueSubject(SearchViewState(status: .idle, recentTerms: [], candidateTerms: [], searchedItems: []))
    }
    
    func load() {
        // load recents
        
    }
}

extension DefaultSearchViewModel: SearchViewModel {
    
    var currentState: SearchViewState {
        _stateChanges.value
    }
    
    var stateChanges: AnyPublisher<SearchViewState, Never> {
        _stateChanges.eraseToAnyPublisher()
    }
    
    func typed(_ text: String) {
        
    }
    
    func search(_ text: String) {
        
    }
    
    // MARK: ResultItemCellDelegate
    func didClickResultItemCell(id: String?) {
        
    }
    
    
}
