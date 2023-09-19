//
//  CandidatesTableViewController.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/09/19.
//

import UIKit
import SwiftUI
import Combine
//protocol SearchResultsTableDelegate: AnyObject {
//    func didSelectCandidate(_ text: String) -> Void
//    func didSelectResult(id: String) -> Void
//}

final class SearchResultsTableViewController: UITableViewController {
    
    // weak var searchResultDelegate: SearchResultsTableDelegate?
    weak var viewModel: SearchViewModel?
    
    private lazy var dataSource = makeDataSource()
    private var cancelBag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.also { it in
            it.allowsSelection = false
            it.delaysContentTouches = true
            it.estimatedRowHeight = CandidateSearchCell.estimatingHeight
            it.rowHeight = UITableView.automaticDimension
            it.register(CandidateSearchCell.self, forCellReuseIdentifier: CandidateSearchCell.reuseIdentifier)
            it.register(SoftwareResultCell.self, forCellReuseIdentifier: SoftwareResultCell.reuseIdentifier)
        }
    }
    
}

extension SearchResultsTableViewController {
    
    fileprivate func updateData(_ data: [ResultItemModel]) {
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
                self.updateView($0)
            }
            .store(in: &cancelBag)
        
    }
    
    private func updateView(_ state: SearchViewState) {
        switch state.status {
            case .typing:
                self.updateData(state.candidateTerms.map({ CandidateItemViewModel(text: $0)}))
            case .result:
                self.updateData(state.searchedItems)
            default:
                break
        }
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Int, ResultItemModel> {
        return UITableViewDiffableDataSource(tableView: self.tableView) { [weak self] tableView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
                case let itemModel as CandidateItemViewModel:
                    let cell = tableView.dequeueReusableCell(withIdentifier: CandidateSearchCell.reuseIdentifier) as! CandidateSearchCell
                    cell.fill(with: itemModel.text)
                    cell.delegate = self?.viewModel
                    return cell
                case let itemModel as SoftwareItemViewModel:
                    let cell = tableView.dequeueReusableCell(withIdentifier: SoftwareResultCell.reuseIdentifier) as! SoftwareResultCell
                    cell.fill(with: itemModel)
                    cell.delegate = self?.viewModel
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
                vc.updateData([
                    CandidateItemViewModel(text: "abc"),
                    CandidateItemViewModel(text: "abc1"),
                    CandidateItemViewModel(text: "abc2")
                ])
            }
        }
        .previewDisplayName("검색 후보")
        
        UIViewControllerPreview {
            SearchResultsTableViewController().also { vc in
                vc.updateData([
                    SoftwareItemViewModel(model: Software.sample())
                ])
            }
        }
        .previewDisplayName("검색 결과")
    }
}
