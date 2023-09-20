//
//  DetailViewController.swift
//  KabangExam
//
//  Created by hyonsoo on 2023/09/20.
//

import UIKit
import SwiftUI

final class DetailViewController: UIViewController {
    static func create(viewModel: DetailViewModel) -> DetailViewController {
        let vc = DetailViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    var viewModel: DetailViewModel?
}


// MARK: -- 미리보기

struct DetailViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            DetailViewController.create(
                viewModel: DefaultDetailViewModel(Software.sample())
            )
        }
    }
}
