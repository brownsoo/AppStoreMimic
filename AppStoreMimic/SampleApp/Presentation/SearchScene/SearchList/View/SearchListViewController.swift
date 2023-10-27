//
//  SearchViewController.swift
//  AppStoreMimic
//
//  Created by hyonsoo on 2023/09/17.
//

import UIKit
import SwiftUI
import Combine

/// 검색 화면 메인

class SearchListViewController: UIViewController {
    
    static func create(viewModel: SearchViewModel) -> SearchListViewController {
        let vc = SearchListViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    var viewModel: SearchViewModel?
    
    private lazy var recentsDataSource = makeDataSource()
    
    private let recentsTableView = UITableView()
    private var searchController: UISearchController?
    private let resultVc = SearchResultsTableViewController()
    private var typingPublisher = PassthroughSubject<String, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewModel?.load()
    }
}

//MARK: -- 결과 셀 선택 처리
extension SearchListViewController: ResultItemCellDelegate {
    func didClickCandidateItemCell(text: String) {
        autoSelectSearchTerm(text)
    }
    
    func didClickResultItemCell(id: String) {
        viewModel?.showDetailView(id: id)
    }
}

extension SearchListViewController: Alertable {
    private func showError(_ message: String) {
        guard !message.isEmpty else { return }
        showAlert(title: "앗!!", message: message)
    }
}
// MARK: -- 뷰 구성, 바인딩
extension SearchListViewController {
    
    fileprivate func updateView(_ state: SearchViewState) {
        foot("\(state.status)")
        switch state.status {
        case .idle:
            var recentsSnap = self.recentsDataSource.snapshot()
            recentsSnap.deleteAllItems()
            recentsSnap.appendSections([0])
            recentsSnap.appendItems(state.recentTerms, toSection: 0)
            self.recentsDataSource.apply(recentsSnap, animatingDifferences: false)
            break
        case .loading:
            self.searchController?.searchBar.searchTextField.resignFirstResponder()
        default:
            // resultVc 에서 처리
            break
        }
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Int, String> {
        return UITableViewDiffableDataSource(tableView: self.recentsTableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: RecentsTermCell.reuseIdentifier) as! RecentsTermCell
            cell.fill(with: itemIdentifier)
            return cell
        }
    }
    
    private func bindData() {
        guard let vm = viewModel else { return }
        vm.stateChanges.receive(on: RunLoop.main)
            .sink {
                self.updateView($0)
            }
            .store(in: &cancelBag)
        
        vm.errorMessages.receive(on: RunLoop.main)
            .sink { self.showError($0) }
            .store(in: &cancelBag)
        
        typingPublisher.throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink {
                vm.typed($0)
            }
            .store(in: &cancelBag)
    }
    
    private func setupViews() {
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //self.definesPresentationContext = true
        self.view.backgroundColor = .systemBackground
        
        // TODO: 큰얼굴아이콘
        let profileIcon = UIImage(systemName: "person.circle")
        let barBt = UIBarButtonItem(customView: UIImageView(image: profileIcon))
        self.navigationItem.rightBarButtonItem = barBt
        
        // 검색 결과 셀 선택 델리게이트
        resultVc.resultCellDelegate = self
        // 뷰 모델 공유
        resultVc.viewModel = self.viewModel
        
        // 검색바 구성
        let searchController = UISearchController(searchResultsController: resultVc)
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.showsSearchResultsController = true
        searchController.delegate = self
        searchController.view.backgroundColor = .systemBackground
        self.searchController = searchController
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "검색"
        
        // 최근 검색어 구성
        view.addSubview(recentsTableView)
        recentsTableView.also { it in
            it.estimatedRowHeight = RecentsTermCell.estimatingHeight
            it.rowHeight = UITableView.automaticDimension
            it.delegate = self
            it.sectionHeaderHeight = UITableView.automaticDimension
            it.register(RecentsTermCell.self, forCellReuseIdentifier: RecentsTermCell.reuseIdentifier)
            it.register(RecentsHeaderCell.self, forHeaderFooterViewReuseIdentifier: RecentsHeaderCell.reuseIdentifier)
        }
        recentsTableView.makeConstraints { it in
            it.edgesConstraintTo(view.safeAreaLayoutGuide, edges: .all)
        }
    }
    
    /// 검색어 선택으로 검색
    private func autoSelectSearchTerm(_ text: String) {
        searchController?.searchBar.becomeFirstResponder()
        searchController?.searchBar.text = text
        viewModel?.search(text)
    }
}


extension SearchListViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        foot("")
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        foot("")
    }
}

extension SearchListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        debugPrint("start")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        debugPrint("end")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        debugPrint("cancel")
        viewModel?.cancelSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        typingPublisher.send(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        foot("search \(text)")
        viewModel?.search(text)
    }
}

extension SearchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecentsHeaderCell.reuseIdentifier)!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = recentsDataSource.snapshot()
        let text = snap.itemIdentifiers[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        autoSelectSearchTerm(text)
    }
}

// MARK: 헤드셀

final class RecentsHeaderCell: UITableViewHeaderFooterView {
    static let reuseIdentifier = String(describing: RecentsHeaderCell.self)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let lb = UILabel()
        lb.text = "최근 검색어"
        lb.font = .boldSystemFont(ofSize: 20)
        contentView.addSubview(lb)
        lb.makeConstraints { it in
            it.leadingAnchorConstraintToSuperview(20)
            it.topAnchorConstraintToSuperview(0)
            it.bottomAnchorConstraintToSuperview(-10)
        }
    }
}


// MARK: 미리보기 --


fileprivate extension SearchViewState {
    func copy(status: SearchStatus) -> SearchViewState {
        var newState = self
        newState.status = status
        return newState
    }
}


struct SearchView_Preview: PreviewProvider {
    
    static let stateIdle = SearchViewState(
        status: .idle,
        recentTerms: ["Alan Walker", "David Guetta", "Avicii", "Marshmello", "Steve Aoki", "R3HAB", "Armin van Buuren", "Skrillex", "Illenium"
                     ],
        candidateTerms: ["Skrillex", "Illenium", "The Chainsmokers"],
        searchedItems: [
            SoftwareItemViewModel(model: Software.sample()),
            SoftwareItemViewModel(model: Software.sample(id: "abc", title: "ABC"))
        ])
    
    static var previews: some View {
        
        UIViewControllerPreview {
            UINavigationController(
                rootViewController: SearchListViewController().also { vc in
                    vc.updateView(stateIdle)
                }
            )
        }
        .previewDisplayName("Light")
        .preferredColorScheme(.light)
        
        UIViewControllerPreview {
            UINavigationController(
                rootViewController: SearchListViewController().also { vc in
                    vc.updateView(stateIdle)
                }
            )
        }
        .previewDisplayName("Dark")
        .preferredColorScheme(.dark)
        
        
        UIViewControllerPreview {
            UINavigationController(
                rootViewController: SearchListViewController().also { vc in
                    vc.updateView(stateIdle.copy(status: .loading))
                }
            )
        }
        .previewDisplayName("Loading")
        
    }
}
