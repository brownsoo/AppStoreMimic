//
//  DetailViewController.swift
//  AppStoreSample
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
    private lazy var headView = DetailHeadView()
    private lazy var stvScreenshots = UIStackView()
    private let placeholderImage = UIImage().solid(UIColor.systemGray5, width: 10, height: 10)
    private let screenBounds = UIScreen.main.bounds
    private var screenRatio: CGFloat {
        screenBounds.height / screenBounds.width
    }
    private var screenshotWidth: CGFloat {
        screenBounds.width * 0.6
    }
    private var screenshotHeight: CGFloat {
        screenshotWidth * screenRatio
    }
    private lazy var descriptionView = DetailDescriptionView()
    private lazy var releaseView = DetailReleaseNoteView()
    private var releaseHiddenConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        if let vm = self.viewModel {
            headView.fill(vm)
            
            vm.screenshots.forEach { url in
                let iv = makeScreenshotView()
                stvScreenshots.addArrangedSubview(iv)
                iv.kf.setImage(
                    with: url,
                    placeholder: placeholderImage,
                    options: [
                        .transition(.fade(0.4)),
                        .cacheOriginalImage
                    ])
            }
            
            descriptionView.text = vm.description
            releaseView.update(version: vm.version, note: vm.releaseNote ?? "")
            releaseView.isHidden = vm.releaseNote == nil
            releaseHiddenConstraint?.isActive = vm.releaseNote == nil
        }
    }
}

extension DetailViewController {
    private func setupViews() {
        
         navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        
        let padding = CGFloat(20)
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.makeConstraints { it in
            it.edgesConstraintTo(view.safeAreaLayoutGuide, edges: .all)
        }
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.makeConstraints { it in
            it.widthAnchorConstraintTo(view.bounds.width)
            it.edgesConstraintToSuperview(edges: .horizontal)
            it.topAnchorConstraintToSuperview()
            it.bottomAnchorConstraintToSuperview()?.priority = .defaultHigh
        }
        
        contentView.addSubview(headView)
        headView.makeConstraints { it in
            it.leadingAnchorConstraintToSuperview()
            it.trailingAnchorConstraintToSuperview()
            it.topAnchorConstraintToSuperview()
        }
        
        // 버전 정보
        contentView.addSubview(releaseView)
        releaseView.setContentHuggingPriority(.required, for: .vertical)
        releaseView.makeConstraints { it in
            it.leadingAnchorConstraintToSuperview(padding)
            it.trailingAnchorConstraintToSuperview(-padding)
            it.topAnchorConstraintTo(headView.bottomAnchor)
        }
        
        // 스크린샷
        let lineScreenshot = UiUtil.makeLine()
        contentView.addSubview(lineScreenshot)
        lineScreenshot.makeConstraints { it in
            releaseHiddenConstraint = it.topAnchorConstraintTo(headView.bottomAnchor)
            releaseHiddenConstraint?.priority = .required
            it.topAnchorConstraintTo(releaseView.bottomAnchor)?.priority = .defaultHigh
            it.heightAnchorConstraintTo(1)
            it.leadingAnchorConstraintToSuperview(padding)
            it.trailingAnchorConstraintToSuperview(-padding)
        }
        
        let lbScreenshotTitle = UiUtil.makeDetailHeadLabel(text: "미리보기")
        contentView.addSubview(lbScreenshotTitle)
        lbScreenshotTitle.makeConstraints { it in
            it.topAnchorConstraintTo(lineScreenshot.bottomAnchor, constant: 10)
            it.leadingAnchorConstraintToSuperview(padding)
        }
        
        let svScreenshots = UIScrollView()
        svScreenshots.showsHorizontalScrollIndicator = false
        svScreenshots.showsVerticalScrollIndicator = false
        contentView.addSubview(svScreenshots)
        svScreenshots.makeConstraints {
            $0.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            $0.heightAnchorConstraintTo(screenshotHeight)
            $0.topAnchorConstraintTo(lbScreenshotTitle.bottomAnchor, constant: 10)
            $0.edgesConstraintToSuperview(edges: .horizontal)
        }
        
        stvScreenshots.also { stack in
            stack.isUserInteractionEnabled = false
            stack.axis = .horizontal
            stack.distribution = .equalSpacing
            stack.spacing = 14
            svScreenshots.addSubview(stack)
            stack.makeConstraints {
                $0.leadingAnchorConstraintToSuperview(padding)
                $0.trailingAnchorConstraintToSuperview(-padding)?.priority = .defaultHigh
                $0.topAnchorConstraintToSuperview()
                $0.bottomAnchorConstraintToSuperview()
            }
        }
        
        // 설명
        
        descriptionView.also { box in
            contentView.addSubview(box)
            box.makeConstraints {
                $0.heightAnchorConstraintTo(100).priority = .defaultLow
                $0.edgesConstraintToSuperview(edges: .horizontal, withInset: padding)
                $0.topAnchorConstraintTo(svScreenshots.bottomAnchor, constant: padding)
                $0.bottomAnchorConstraintToSuperview(-100)?.priority = .defaultHigh
            }
        }
    }
    
    private func makeScreenshotView() -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGray4
        iv.layer.cornerRadius = DetailHeadView.iconRounding
        iv.layer.borderColor = UIColor.systemGray3.cgColor
        iv.layer.borderWidth = 0.5
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: screenshotHeight).isActive = true
        iv.widthAnchor.constraint(equalToConstant: screenshotWidth).isActive = true
        return iv
    }
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
