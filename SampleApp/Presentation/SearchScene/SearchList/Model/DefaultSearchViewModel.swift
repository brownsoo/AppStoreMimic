//
//  DefaultSearchViewModel.swift
//  AppStoreSample
//
//  Created by hyonsoo han on 2023/09/19.
//

import Foundation
import Combine

/// 기본 SearchViewModel implements

final class DefaultSearchViewModel: BaseViewModel {
    private let repository: iTunesRepository
    private let _stateChanges = CurrentValueSubject<SearchViewState, Never>(
        SearchViewState(status: .idle, recentTerms: [], candidateTerms: [], searchedItems: [])
    )
    private var searchTask: Cancellable? {
        willSet {
            searchTask?.cancel()
        }
    }
    private var candidatesTask: Cancellable? {
        willSet {
            candidatesTask?.cancel()
        }
    }
    private let mainQueue = DispatchQueue.main
    private var resultItems: [Software] = []
    private let actions: SearchListViewActions
    
    init(repository: iTunesRepository, actions: SearchListViewActions) {
        self.repository = repository
        self.actions = actions
    }
    
    override func load() {
        loadRecents()
    }
    
    private func loadRecents() {
        repository.searchRecents("") { items in
            var state = self.currentState
            state.recentTerms = items
            self._stateChanges.send(state)
        }
    }
}

extension DefaultSearchViewModel: SearchViewModel {
    
    var currentState: SearchViewState {
        _stateChanges.value
    }
    
    var stateChanges: AnyPublisher<SearchViewState, Never> {
        _stateChanges.eraseToAnyPublisher()
    }
    
    func cancelSearch() {
        candidatesTask?.cancel()
        searchTask?.cancel()
        var state = self.currentState
        state.status = .idle
        state.candidateTerms = []
        _stateChanges.send(state)
    }
    
    func typed(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            var state = self.currentState
            state.candidateTerms = []
            state.status = .typing
            self._stateChanges.send(state)
            return
        }
        candidatesTask = repository.searchRecents(text, onResult: { items in
            var state = self.currentState
            state.candidateTerms = items
            state.status = .typing
            self._stateChanges.send(state)
        })
    }
    
    func search(_ text: String) {
        var state = self.currentState
        state.status = .loading
        state.searchedItems = []
        _stateChanges.send(state)
        
        // 검색어 저장
        let _ = repository.saveSearchTerm(text)
        mainQueue.async {
            self.loadRecents()
        }
        
        // 검색
        searchTask = repository.searchSoftware(text, onResult: { [weak self] result in
            guard let this = self else { return }
            var state = this.currentState
            state.status = .result
            switch result {
                case .success(let items):
                    state.searchedItems = items.map { SoftwareItemViewModel(model: $0) }
                    this.resultItems = items
                case .failure(let error):
                    if let e = error.asAppError, case AppError.contentNotChanged = e {
                        // not changed
                    } else {
                        this.handleError(error)
                    }
                    state.searchedItems = []
                    this.resultItems = []
            }
            this._stateChanges.send(state)
        })
    }
    
    func showDetailView(id: String) {
        if let selected = self.resultItems.first(where: { $0.id == id }) {
            actions.showSoftwareDetail(selected)
        }
    }
}
