//
//  DetailHeadView.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/09/20.
//

import UIKit
import SwiftUI
import Kingfisher

final class DetailHeadView: UIView {
    
    static private let iconSize = CGSize(width: 100, height: 100)
    static private let iconRounding = CGFloat(24)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private let ivIcon = UIImageView()
    private let lbTitle = UILabel()
    private let lbSubtitle = UILabel()
    private let ratingView = RatingView()
    private let lbRatingCount = UILabel()
    private let lbSeller = UILabel()
    private let lbGenre = UILabel()
    private let svScreenshots = UIStackView()
    private let imageProcessor = DownsamplingImageProcessor(size: iconSize)
    private let placeholderImage = UIImage().solid(UIColor.systemGray5, width: 10, height: 10)
    
    func fill(_ model: DetailViewModel) {
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
    }
}

extension DetailHeadView {
    private func setupViews() {
        
        let padding: CGFloat = 20
        ivIcon.also { it in
            it.isUserInteractionEnabled = false
            it.backgroundColor = .systemGray4
            it.layer.cornerRadius = DetailHeadView.iconRounding
            it.layer.borderColor = UIColor.systemGray3.cgColor
            it.layer.borderWidth = 0.5
            it.layer.masksToBounds = true
            addSubview(it)
            it.makeConstraints {
                $0.sizeAnchorConstraintTo(DetailHeadView.iconSize.width)
                $0.leadingAnchorConstraintToSuperview(padding)
                $0.topAnchorConstraintToSuperview(padding)
            }
        }
        
        // 타이틀 범위
        lbTitle.font = .boldSystemFont(ofSize: 20)
        lbTitle.numberOfLines = 2
        lbSubtitle.textColor = UIColor.secondaryLabel
        lbSubtitle.font = .systemFont(ofSize: 16)
        lbSubtitle.numberOfLines = 2
        let svTitle = UIStackView(arrangedSubviews: [lbTitle, lbSubtitle])
        svTitle.also { it in
            it.isUserInteractionEnabled = false
            it.axis = .vertical
            it.spacing = 4
            it.distribution = .equalCentering
            it.setContentHuggingPriority(.required, for: .vertical)
            it.setContentCompressionResistancePriority(.required, for: .vertical)
        }
        
        
        let btInstall = UIButton(type: .custom).also { it in
            it.setTitle("받기", for: .normal)
            it.titleLabel?.font = .boldSystemFont(ofSize: 16)
            it.titleLabel?.adjustsFontSizeToFitWidth = true
            it.setContentHuggingPriority(.required, for: .horizontal)
            it.backgroundColor = .link
            it.layer.cornerRadius = 15
            it.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        }
        
        let btShare = UIButton(type: .custom).also { it in
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .default)
            it.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: config), for: .normal)
        }
        let installArea = UIStackView(arrangedSubviews: [btInstall, btShare]).also { it in
            it.axis = .horizontal
            it.distribution = .equalSpacing
            it.setContentHuggingPriority(.required, for: .vertical)
            it.setContentCompressionResistancePriority(.required, for: .vertical)
        }
        
        let svTitleArea = UIStackView(arrangedSubviews: [svTitle, installArea]).also { it in
            it.axis = .vertical
            it.distribution = .equalSpacing
            addSubview(it)
            it.makeConstraints {
                $0.leadingAnchorConstraintTo(ivIcon.trailingAnchor, constant: padding)
                $0.trailingAnchorConstraintToSuperview(-padding)
                $0.topAnchorConstraintTo(ivIcon)
                $0.bottomAnchorConstraintTo(ivIcon)
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
            UIImageView(image: UIImage(systemName: "person.crop.square")?
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
        let infoStack = UIStackView(arrangedSubviews: [rating, genre, seller]).also { it in
            it.axis = .horizontal
            it.alignment = .center
            it.distribution = .equalSpacing
            it.spacing = 4
            it.isUserInteractionEnabled = false
            it.setContentHuggingPriority(.required, for: .vertical)
            it.setContentCompressionResistancePriority(.required, for: .vertical)
            
        }
        
        UIScrollView().also { sv in
            addSubview(sv)
            sv.alwaysBounceVertical = false
            sv.addSubview(infoStack)
            sv.makeConstraints {
                $0.leadingAnchorConstraintToSuperview(padding)
                $0.trailingAnchorConstraintToSuperview(-padding)
                $0.topAnchorConstraintTo(ivIcon.bottomAnchor, constant: 10)
                $0.bottomAnchorConstraintToSuperview(-padding)?.priority = .fittingSizeLevel
            }
            infoStack.makeConstraints {
                $0.leadingAnchorConstraintToSuperview()
                $0.topAnchorConstraintToSuperview()
                $0.bottomAnchorConstraintToSuperview()
                $0.trailingAnchorConstraintToSuperview()?.priority = .defaultLow
            }
        }
        
    }
}



// MARK: -- 미리보기

struct DetailHeadView_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            DetailHeadView().also { v in
                v.fill(DefaultDetailViewModel(Software.sample()))
            }
        }
    }
}
