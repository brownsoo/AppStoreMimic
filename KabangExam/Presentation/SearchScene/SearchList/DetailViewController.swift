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
