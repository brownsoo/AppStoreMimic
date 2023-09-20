//
//  CandidatesTableViewController.swift
//  AppStoreSample
//
//  Created by hyonsoo han on 2023/09/19.
//

import UIKit
import SwiftUI
import Combine

final class SearchResultsTableViewController: UITableViewController {
    
    weak var resultCellDelegate: ResultItemCellDelegate?
    weak var viewModel: SearchViewModel?
    
    private lazy var dataSource = makeDataSource()
    private var cancelBag = Set<AnyCancellable>()
    private lazy var loadingView = UIView()
    private lazy var activityView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.also { it in
            it.allowsSelection = false
            it.delaysContentTouches = true
            it.estimatedRowHeight = CandidateSearchCell.estimatingHeight
            it.rowHeight = UITableView.automaticDimension
            it.keyboardDismissMode = .onDrag
            it.register(CandidateSearchCell.self, forCellReuseIdentifier: CandidateSearchCell.reuseIdentifier)
            it.register(SoftwareResultCell.self, forCellReuseIdentifier: SoftwareResultCell.reuseIdentifier)
        }
        
        // 로딩뷰
        view.addSubview(loadingView)
        loadingView.backgroundColor = .black.withAlphaComponent(0.2)
        loadingView.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        loadingView.makeConstraints { it in
            it.leadingAnchorConstraintToSuperview()
            it.topAnchorConstraintToSuperview()
            it.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
            it.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        }
        loadingView.addSubview(activityView)
        loadingView.isHidden = true
        activityView.hidesWhenStopped = true
        activityView.makeConstraints {
            $0.centerXAnchorConstraintToSuperview()
            $0.centerYAnchorConstraintToSuperview()
        }
        
        bindData()
    }
    
}

extension SearchResultsTableViewController {
    
    fileprivate func updateDataSource(_ data: [ResultItemModel]) {
        var snap = self.dataSource.snapshot()
        snap.deleteAllItems()
        snap.appendSections([0])
        snap.appendItems(data, toSection: 0)
        self.dataSource.apply(snap, animatingDifferences: false)
    }
    
    private func bindData() {
        guard let vm = viewModel else { return }
        vm.stateChanges.receive(on: RunLoop.main)
            .sink {
                self.updateView(state: $0)
            }
            .store(in: &cancelBag)
        
    }
    
    private func updateView(state: SearchViewState) {
        switch state.status {
        case .typing, .idle:
            loadingView.isHidden = true
            tableView.estimatedRowHeight = CandidateSearchCell.estimatingHeight
            self.updateDataSource(state.candidateTerms.map({ CandidateItemViewModel(text: $0)}))
        case .loading:
            loadingView.isHidden = false
            view.bringSubviewToFront(loadingView)
            if !activityView.isAnimating {
                activityView.startAnimating()
            }
            // 검색어 제안 목록인 경우에만 없애기
            let snap = self.dataSource.snapshot()
            if let first = snap.itemIdentifiers.first, first is CandidateItemViewModel {
                self.updateDataSource([])
            }
        case .result:
            loadingView.isHidden = true
            tableView.estimatedRowHeight = SoftwareResultCell.estimatingHeight
            self.updateDataSource(state.searchedItems)
        }
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Int, ResultItemModel> {
        return UITableViewDiffableDataSource(tableView: self.tableView) { [weak self] tableView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case let itemModel as CandidateItemViewModel:
                let cell = tableView.dequeueReusableCell(withIdentifier: CandidateSearchCell.reuseIdentifier) as! CandidateSearchCell
                cell.fill(with: itemModel.text)
                cell.delegate = self?.resultCellDelegate
                return cell
            case let itemModel as SoftwareItemViewModel:
                let cell = tableView.dequeueReusableCell(withIdentifier: SoftwareResultCell.reuseIdentifier) as! SoftwareResultCell
                cell.fill(with: itemModel)
                cell.delegate = self?.resultCellDelegate
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = dataSource.snapshot()
        let itemIdentifier = snap.itemIdentifiers[indexPath.row]
        if let item = itemIdentifier as? CandidateItemViewModel {
            self.didSelectCandidate(item.text)
        } else if let item = itemIdentifier as? SoftwareItemViewModel {
            self.didSelectResult(id: item.id)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



extension SearchResultsTableViewController {
    func didSelectCandidate(_ text: String) {
        viewModel?.search(text)
    }
    
    func didSelectResult(id: String) {
        // TODO: 상세화면
    }
    
}

// MARK: -- 미리보기

struct CandidatesTableViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SearchResultsTableViewController().also { vc in
                vc.updateDataSource([
                    CandidateItemViewModel(text: "abc"),
                    CandidateItemViewModel(text: "abc1"),
                    CandidateItemViewModel(text: "abc2")
                ])
            }
        }
        .previewDisplayName("검색 후보")
        
        UIViewControllerPreview {
            SearchResultsTableViewController().also { vc in
                vc.updateDataSource([
                    SoftwareItemViewModel(model: Software.sample())
                ])
            }
        }
        .previewDisplayName("검색 결과")
    }
}
