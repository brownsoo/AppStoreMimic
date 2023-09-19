//
//  SearchViewModel.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/09/19.
//

import Foundation
import Combine

enum SearchStatus {
    case idle
    case searching
    case loading
    case result
}

struct SearchViewState {
    var status: SearchStatus
    var recentTerms: [String]
    var candidateTerms: [String]
    var searchedItems: [SoftwareItemViewModel]
}

protocol SearchViewModel: ViewModel, ResultItemCellDelegate {
    // -- out
    var currentState: SearchViewState { get }
    var stateChanges: AnyPublisher<SearchViewState, Never> { get }
    // -- in
    func typed(_ text: String)
    func search(_ text: String)
}
