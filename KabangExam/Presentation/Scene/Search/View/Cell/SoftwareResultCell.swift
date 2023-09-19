//
//  SoftwareResultCell.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/09/18.
//

import UIKit
import SwiftUI
import Kingfisher

final class SoftwareResultCell: UITableViewCell {
    static let reuseIdentifier = String(describing: SoftwareResultCell.self)
    static let estimatingHeight: CGFloat = 36
    static private let iconSize = CGSize(width: 60, height: 60)
    static private let iconRounding = CGFloat(8)
    static private let screenshotRounding = CGFloat(8)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    weak var delegate: ResultItemCellDelegate?
    private var id: String? = nil
    
    private let btTrans = UIButton()
    private let ivIcon = UIImageView()
    private let lbTitle = UILabel()
    private let ratingView = RatingView()
    private let lbRatingCount = UILabel()
    private let svScreenshots = UIStackView()
    private let imageProcessor = DownsamplingImageProcessor(size: iconSize)
    private let placeholderImage = UIImage().solid(UIColor.systemGray5, width: 10, height: 10)
    
    func fill(with model: SoftwareItemViewModel) {
        self.id = model.id
        ivIcon.kf.setImage(with: model.iconUrl,
        placeholder: placeholderImage,
        options: [
            KingfisherOptionsInfoItem.processor(imageProcessor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(0.4)),
            .cacheOriginalImage
        ])
        lbTitle.text = model.title
        lbRatingCount.text = model.userRatingCount
        ratingView.rate = CGFloat(model.userRating)
        svScreenshots.arrangedSubviews.enumerated().forEach {
            let index = $0.offset
            ($0.element as? UIImageView)?.also { iv in
                if let url = model.screenshots.get(at: index) {
                    iv.kf.setImage(
                        with: url,
                        options: [
                            .transition(.fade(0.4)),
                            .cacheOriginalImage
                        ])
                } else {
                    iv.image = nil
                }
            }
        }
    }
    
    
}

extension SoftwareResultCell {
    
    @objc
    private func didClick() {
        if let id = self.id {
            delegate?.didClickResultItemCell(id: id)
        }
    }
    
    private func setupViews() {
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.makeConstraints { it in
//            it.edgesConstraintToSuperview(edges: .all)
//        }
//        contentView.setContentHuggingPriority(.required, for: .vertical)
//        contentView.setContentCompressionResistancePriority(.required, for: .vertical)
        btTrans.also { it in
            it.setBackgroundImage(UIImage().solid(.systemGray6, width: 10, height: 10).resizableImage(withCapInsets: .zero), for: .highlighted)
            it.addTarget(self, action: #selector(didClick), for: .touchUpInside)
            contentView.addSubview(it)
            it.makeConstraints {
                $0.edgesConstraintToSuperview(edges: .all)
            }
        }
        
        let padding: CGFloat = 20
        ivIcon.also { it in
            it.isUserInteractionEnabled = false
            it.backgroundColor = .systemGray4
            it.layer.cornerRadius = SoftwareResultCell.iconRounding
            it.layer.borderColor = UIColor.systemGray3.cgColor
            it.layer.borderWidth = 0.5
            it.layer.masksToBounds = true
            contentView.addSubview(it)
            it.makeConstraints {
                $0.sizeAnchorConstraintTo(SoftwareResultCell.iconSize.width)
                $0.leadingAnchorConstraintToSuperview(padding)
                $0.topAnchorConstraintToSuperview(padding)
            }
        }
        
        let btInstall = UIButton(type: .system)
        btInstall.also { it in
            it.setTitle("받기", for: .normal)
            it.titleLabel?.font = .boldSystemFont(ofSize: 14)
            it.titleLabel?.adjustsFontSizeToFitWidth = true
            it.sizeToFit()
            it.setContentHuggingPriority(.required, for: .horizontal)
            it.backgroundColor = .systemGray5
            it.layer.cornerRadius = 15
            it.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
            contentView.addSubview(it)
            it.makeConstraints {
                $0.heightAnchorConstraintTo(30)
                $0.trailingAnchorConstraintToSuperview(-padding)
                $0.centerYAnchorConstraintTo(ivIcon.centerYAnchor)
            }
        }
        
        let svRating = UIStackView(arrangedSubviews: [ratingView, lbRatingCount])
        svRating.axis = .horizontal
        svRating.alignment = .center
        svRating.spacing = 4
        lbRatingCount.also {
            $0.textColor = .secondaryLabel
            $0.font = .systemFont(ofSize: 12)
        }
        
        lbTitle.also { it in
            it.font = .boldSystemFont(ofSize: 16)
        }
        let svHead = UIStackView(arrangedSubviews: [
            lbTitle, svRating
        ])
        svHead.also { it in
            it.isUserInteractionEnabled = false
            it.axis = .vertical
            it.distribution = .equalCentering
            it.alignment = .leading
            it.setContentHuggingPriority(.defaultLow, for: .horizontal)
            it.setContentHuggingPriority(.defaultLow, for: .vertical)
            it.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            it.setContentCompressionResistancePriority(.required, for: .vertical)
            contentView.addSubview(it)
            it.makeConstraints {
                $0.leadingAnchorConstraintTo(ivIcon.trailingAnchor, constant: 10)
                $0.trailingAnchorConstraintTo(btInstall.leadingAnchor, constant: -10)
                $0.topAnchorConstraintTo(ivIcon.topAnchor)
                $0.bottomAnchorConstraintTo(ivIcon.bottomAnchor)
            }
        }
        
        let screenBounds = UIScreen.main.bounds
        let screenRatio = screenBounds.height / screenBounds.width
        let spacing: CGFloat = 10
        let screenshotWidth = (contentView.bounds.width - padding * 2 - spacing * 2) / 3
        let screenshotHeight = screenshotWidth * screenRatio

        svScreenshots.also { it in
            it.isUserInteractionEnabled = false
            it.axis = .horizontal
            it.distribution = .fillEqually
            it.spacing = 10
            it.setContentCompressionResistancePriority(.required, for: .vertical)
            it.setContentHuggingPriority(.required, for: .vertical)
            contentView.addSubview(it)
            it.makeConstraints {
                $0.heightAnchorConstraintTo(screenshotHeight)
                $0.leadingAnchorConstraintToSuperview(padding)
                $0.trailingAnchorConstraintToSuperview(-padding)
                $0.topAnchorConstraintTo(ivIcon.bottomAnchor, constant: 20)
                $0.bottomAnchorConstraintToSuperview(-padding)?.priority = .defaultHigh
            }
            for _ in 0..<3 {
                let iv = UIImageView()
                iv.contentMode = .scaleAspectFill
                iv.backgroundColor = .systemGray4
                iv.layer.cornerRadius = SoftwareResultCell.screenshotRounding
                iv.layer.borderColor = UIColor.systemGray3.cgColor
                iv.layer.borderWidth = 0.5
                iv.layer.masksToBounds = true
                it.addArrangedSubview(iv)
            }
        }
    }
}

struct SoftwareResultCell_Preview: PreviewProvider {
    static var previews: some View {
        let cell1 = SoftwareResultCell()
        UIViewPreview {
            cell1
        }.onAppear {
            cell1.fill(with: SoftwareItemViewModel(model: Software.sample()))
        }
    }
    
}
