//
//  SearchViewController.swift
//  KabangExam
//
//  Created by hyonsoo on 2023/09/17.
//

import UIKit
import SwiftUI
import Combine

class SearchListViewController: UIViewController {
    
    static func create(viewModel: SearchViewModel) -> SearchListViewController {
        let vc = SearchListViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    var viewModel: SearchViewModel?

    private let recentsTableView = UITableView()
    private lazy var recentsDataSource = makeDataSource()
    private var searchController: UISearchController?
    private let resultVc = SearchResultsTableViewController()
    private lazy var activityView = UIActivityIndicatorView(style: .large)
    private var typingPublisher = PassthroughSubject<String, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
}

extension SearchListViewController: Alertable {
    private func showError(_ message: String) {
        guard !message.isEmpty else { return }
        showAlert(title: "앗!!", message: message)
    }
}

extension SearchListViewController {
    
    fileprivate func updateView(_ state: SearchViewState) {
        switch state.status {
            case .idle:
                activityView.isHidden = true
                var recentsSnap = self.recentsDataSource.snapshot()
                recentsSnap.deleteAllItems()
                recentsSnap.appendSections([0])
                recentsSnap.appendItems(state.recentTerms, toSection: 0)
                self.recentsDataSource.apply(recentsSnap, animatingDifferences: false)
                // navigationItem.largeTitleDisplayMode = .automatic
                break
            case .typing:
                //navigationItem.largeTitleDisplayMode = .never
                activityView.isHidden = true
//                resultVc.updateData(state.candidateTerms.map({ CandidateItemViewModel(text: $0)}))
            case .loading:
                if activityView.isHidden {
                    activityView.isHidden = false
                    activityView.startAnimating()
                }
                break
            case .result:
                activityView.isHidden = true
                break
        }
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Int, String> {
        return UITableViewDiffableDataSource(tableView: self.recentsTableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: RecentsSearchCell.reuseIdentifier) as! RecentsSearchCell
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
        
        typingPublisher.throttle(for: 500, scheduler: RunLoop.main, latest: true)
            .sink {
                vm.typed($0)
            }
            .store(in: &cancelBag)
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.definesPresentationContext = true
        // TODO: 큰얼굴아이콘 
        let profileIcon = UIImage(systemName: "person.circle")
        let barBt = UIBarButtonItem(customView: UIImageView(image: profileIcon))
        self.navigationItem.rightBarButtonItem = barBt
        // TODO: result controller
        
        // 검색어 제안
        // resultVc.searchResultDelegate = self
        resultVc.viewModel = self.viewModel
        
        // 검색바 구성
        let searchController = UISearchController(searchResultsController: resultVc)
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.showsSearchResultsController = true
        searchController.delegate = self
        self.searchController = searchController
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "검색"
        
        // 최근 검색어 구성
        view.addSubview(recentsTableView)
        recentsTableView.also { it in
            it.estimatedRowHeight = RecentsSearchCell.estimatingHeight
            it.rowHeight = UITableView.automaticDimension
            it.delegate = self
            it.sectionHeaderHeight = UITableView.automaticDimension
            it.register(RecentsSearchCell.self, forCellReuseIdentifier: RecentsSearchCell.reuseIdentifier)
            it.register(RecentsHeaderCell.self, forHeaderFooterViewReuseIdentifier: RecentsHeaderCell.reuseIdentifier)
        }
        recentsTableView.makeConstraints { it in
            it.edgesConstraintTo(view.safeAreaLayoutGuide, edges: .all)
        }
        
        // 로딩뷰
        view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.makeConstraints {
            $0.centerXAnchorConstraintToSuperview()
            $0.centerYAnchorConstraintToSuperview()
        }
    }
}


extension SearchListViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        foot("")
        //viewModel?.enterSearch()
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        foot("")
        //viewModel?.exitSearch()
    }
}

extension SearchListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        debugPrint(searchText)
        //viewModel?.typed(searchController.searchBar.text ?? "")
        typingPublisher.send(searchText)
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
        //
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        debugPrint("search \(text)")
        viewModel?.search(text)
    }
}

extension SearchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let state = viewModel?.currentState.status ?? .idle
        if viewModel == nil || state != .idle {
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecentsHeaderCell.reuseIdentifier)!
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = recentsDataSource.snapshot()
        let text = snap.itemIdentifiers[indexPath.row]
        viewModel?.search(text)
        tableView.deselectRow(at: indexPath, animated: true)
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
        
//        UIViewControllerPreview {
//            UINavigationController(
//                rootViewController: SearchViewController().also { vc in
//                    vc.updateView(stateIdle.copy(status: .result))
//                }
//            )
//        }
//        .previewDisplayName("결과")
        
//        UIViewControllerPreview {
//            UINavigationController(
//                rootViewController: SearchViewController().also { vc in
//                    vc.updateView(stateIdle.copy(status: .loading))
//                }
//            )
//        }
//        .previewDisplayName("Loading")
        
//        UIViewControllerPreview {
//            UINavigationController(
//                rootViewController: SearchViewController().also { vc in
//                    vc.updateView(stateIdle.copy(status: .typing))
//                }
//            )
//        }
//        .previewDisplayName("뷰모델적용")
        
        UIViewControllerPreview {
            UINavigationController(
                rootViewController: SearchListViewController().also { vc in
                    vc.updateView(stateIdle)
                }
            )
        }
        .previewDisplayName("기본상태")
    }
}
