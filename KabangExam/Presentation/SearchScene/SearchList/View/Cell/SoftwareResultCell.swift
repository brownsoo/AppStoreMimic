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
    static private let iconSize = CGSize(width: 64, height: 64)
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
    private let lbSubtitle = UILabel()
    private let ratingView = RatingView()
    private let lbRatingCount = UILabel()
    private let lbSeller = UILabel()
    private let lbGenre = UILabel()
    private let stvScreenshots = UIStackView()
    private let imageProcessor = DownsamplingImageProcessor(size: iconSize)
    private let placeholderImage = UIImage().solid(UIColor.systemGray5, width: 10, height: 10)
    
    func fill(with model: SoftwareItemViewModel) {
        self.id = model.id
        ivIcon.kf.setImage(
            with: model.iconUrl,
            placeholder: placeholderImage,
            options: [
                KingfisherOptionsInfoItem.processor(imageProcessor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.4)),
                .cacheOriginalImage
            ])
        lbTitle.text = model.title
        lbSubtitle.text = model.subtitle
        lbRatingCount.text = model.userRatingCount
        ratingView.rate = CGFloat(model.userRating)
        lbSeller.text = model.sellerName
        lbGenre.text = model.genre
        
        stvScreenshots.arrangedSubviews.enumerated().forEach {
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
        
        setNeedsLayout()
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
        btTrans.also { it in
            it.setBackgroundImage(UIImage().solid(.systemGray6, width: 10, height: 10).resizableImage(withCapInsets: .zero), for: .highlighted)
            it.addTarget(self, action: #selector(didClick), for: .touchUpInside)
            it.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
            it.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
            contentView.addSubview(it)
            it.makeConstraints {
                $0.edgesConstraintToSuperview(edges: .all, priority: .defaultLow)
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
            it.titleLabel?.font = .boldSystemFont(ofSize: 15)
            it.titleLabel?.adjustsFontSizeToFitWidth = true
            it.setContentHuggingPriority(.required, for: .horizontal)
            it.backgroundColor = .systemGray5
            it.layer.cornerRadius = 15
            it.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
            contentView.addSubview(it)
            it.makeConstraints {
                $0.trailingAnchorConstraintToSuperview(-padding)
                $0.centerYAnchorConstraintTo(ivIcon.centerYAnchor)
            }
        }
        
        // 타이틀 범위
        lbTitle.font = .boldSystemFont(ofSize: 16)
        lbSubtitle.textColor = UIColor.secondaryLabel
        lbSubtitle.font = .systemFont(ofSize: 12)
        let svTitle = UIStackView(arrangedSubviews: [lbTitle, lbSubtitle])
        svTitle.also { it in
            it.isUserInteractionEnabled = false
            it.axis = .vertical
            it.spacing = 2
            it.distribution = .equalCentering
            it.setContentHuggingPriority(.required, for: .vertical)
            it.setContentCompressionResistancePriority(.required, for: .vertical)
            contentView.addSubview(it)
            it.makeConstraints {
                $0.leadingAnchorConstraintTo(ivIcon.trailingAnchor, constant: 10)
                $0.trailingAnchorConstraintTo(btInstall.leadingAnchor, constant: -10)
                $0.centerYAnchorConstraintTo(ivIcon)
            }
        }
        
        let infoFont = UIFont.boldSystemFont(ofSize: 12)
        let infoColor = UIColor.systemGray
        // 평가
        lbRatingCount.also {
            $0.font = infoFont
            $0.textColor = infoColor
        }
        let rating = UIStackView(arrangedSubviews: [ratingView, lbRatingCount]).also { it in
            it.axis = .horizontal
            it.spacing = 2
            it.setContentHuggingPriority(.required, for: .horizontal)
            it.setContentHuggingPriority(.required, for: .vertical)
            it.setContentCompressionResistancePriority(.required, for: .horizontal)
            it.setContentCompressionResistancePriority(.required, for: .vertical)
        }
        
        // 판매자
        lbSeller.font = infoFont
        lbSeller.textColor = infoColor
        let seller = UIStackView(arrangedSubviews: [
            UIImageView(image: UIImage(systemName: "person.crop.square")?
                        .withRenderingMode(.alwaysOriginal)
                        .withTintColor(infoColor)),
            lbSeller
        ]).also { it in
            it.axis = .horizontal
            it.spacing = 2
            it.setContentHuggingPriority(.required, for: .horizontal)
            it.setContentHuggingPriority(.required, for: .vertical)
            it.setContentCompressionResistancePriority(.required, for: .horizontal)
            it.setContentCompressionResistancePriority(.required, for: .vertical)
        }
        
        // 장르
        lbGenre.font = infoFont
        lbGenre.textColor = infoColor
        let genre = UIStackView(arrangedSubviews: [
            UIImageView(image: UIImage(systemName: "lightbulb")?
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(infoColor)),
            lbGenre
        ]).also { it in
            it.axis = .horizontal
            it.spacing = 2
            it.setContentHuggingPriority(.required, for: .horizontal)
            it.setContentHuggingPriority(.required, for: .vertical)
            it.setContentCompressionResistancePriority(.required, for: .horizontal)
            it.setContentCompressionResistancePriority(.required, for: .vertical)
        }
        
        // 하단 라인
        let infoStack = UIStackView(arrangedSubviews: [rating, seller, genre]).also { it in
            contentView.addSubview(it)
            it.axis = .horizontal
            it.alignment = .center
            it.distribution = .equalSpacing
            it.spacing = 4
            it.isUserInteractionEnabled = false
            it.setContentHuggingPriority(.required, for: .vertical)
            it.setContentCompressionResistancePriority(.required, for: .vertical)
            it.makeConstraints {
                $0.leadingAnchorConstraintToSuperview(padding)
                $0.trailingAnchorConstraintToSuperview(-padding)
                $0.topAnchorConstraintTo(ivIcon.bottomAnchor, constant: 14)
            }
        }
        
        // 스크린샷
        let screenBounds = UIScreen.main.bounds
        let screenRatio = screenBounds.height / screenBounds.width
        let spacing: CGFloat = 10
        let screenshotWidth = (contentView.bounds.width - padding * 2 - spacing * 2) / 3
        let screenshotHeight = screenshotWidth * screenRatio

        stvScreenshots.also { it in
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
                $0.topAnchorConstraintTo(infoStack.bottomAnchor, constant: 10)
                $0.bottomAnchorConstraintToSuperview(-padding)?.priority = .fittingSizeLevel
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
