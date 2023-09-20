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
    static let iconRounding = CGFloat(24)
    
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
    private let ratingView = RatingView(progress: 0, color: .gray)
    private let lbRating = UILabel()
    private let lbRatingCount = UILabel()
    private let lbContentAge = UILabel()
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
        ratingView.rate = model.userRating
        lbRating.text = NumberFormatter().also(perform: { f in
            f.numberStyle = .decimal
            f.maximumFractionDigits = 1
        }).string(from: NSNumber(value: model.userRating))
        lbRatingCount.text = model.userRatingCount
        lbContentAge.text = model.contentAdvisoryRating
        lbSeller.text = model.seller
        lbGenre.text = model.genre
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
        
        //MARK: 타이틀 범위
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
        
        UIStackView(arrangedSubviews: [svTitle, installArea]).also { it in
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
        
        // MARK: INFO line
        let infoBoxHeight = CGFloat(100)
        let infoStack = UIStackView().also { it in
            it.axis = .horizontal
            it.alignment = .center
            it.distribution = .equalSpacing
            it.spacing = 4
            it.isUserInteractionEnabled = false
            it.setContentHuggingPriority(.required, for: .vertical)
            it.setContentCompressionResistancePriority(.required, for: .vertical)
            let line = UIView()
            it.addSubview(line)
            line.makeConstraints {
                $0.heightAnchorConstraintTo(1)
                $0.backgroundColor = .systemGray3
                $0.leadingAnchorConstraintToSuperview()?.priority = .fittingSizeLevel
                $0.trailingAnchorConstraintToSuperview()?.priority = .fittingSizeLevel
            }
        }
        UIScrollView().also { sv in
            addSubview(sv)
            sv.alwaysBounceVertical = false
            sv.showsHorizontalScrollIndicator = false
            sv.showsVerticalScrollIndicator = false
            sv.addSubview(infoStack)
            sv.makeConstraints {
                $0.leadingAnchorConstraintToSuperview(padding)
                $0.trailingAnchorConstraintToSuperview(-padding)
                $0.topAnchorConstraintTo(ivIcon.bottomAnchor, constant: 10)
                $0.bottomAnchorConstraintToSuperview(-padding)?.priority = .fittingSizeLevel
                $0.heightAnchorConstraintTo(infoBoxHeight)
            }
            infoStack.makeConstraints {
                $0.leadingAnchorConstraintToSuperview()
                $0.topAnchorConstraintToSuperview()
                $0.bottomAnchorConstraintToSuperview()?.priority = .defaultHigh
                $0.trailingAnchorConstraintToSuperview()
            }
        }
        
        let infoFont = UIFont.boldSystemFont(ofSize: 12)
        let infoColor = UIColor.systemGray
        let mainFont = UIFont.boldSystemFont(ofSize: 24)
        
        // 평가
        lbRatingCount.font = infoFont
        lbRatingCount.textColor = infoColor
        lbRating.font = mainFont
        lbRating.textColor = infoColor
        infoStack.addArrangedSubview(
            makeInfoBox(label: lbRatingCount, main: lbRating, info: ratingView,
                        boxHeight: infoBoxHeight,
                        lining: true)
        )
        // 연령
        lbContentAge.font = mainFont
        lbContentAge.textColor = infoColor
        let lbAge = UILabel()
        lbAge.text = "연령"
        lbAge.font = infoFont
        lbAge.textColor =  infoColor
        let lbSe = UILabel()
        lbSe.text = "세"
        lbSe.font = infoFont
        lbSe.textColor =  infoColor
        infoStack.addArrangedSubview(
            makeInfoBox(label: lbAge, main: lbContentAge, info: lbSe,
                        boxHeight: infoBoxHeight,
                        lining: true)
        )
        // 판매자
        lbSeller.font = infoFont
        lbSeller.textColor = infoColor
        let lbMaker = UILabel()
        lbMaker.text = "개발자"
        lbMaker.font = infoFont
        lbMaker.textColor =  infoColor
        
        let ivMaker = UIImageView(image:UIImage(systemName: "person.crop.square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .default))?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(infoColor))
        infoStack.addArrangedSubview(
            makeInfoBox(label: lbMaker, main: ivMaker, info: lbSeller,
                        boxHeight: infoBoxHeight,
                        lining: true)
        )
        // 장르
        lbGenre.font = infoFont
        lbGenre.textColor = infoColor
        let ivGenre = UIImageView(image:UIImage(systemName: "questionmark.diamond", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .default))?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(infoColor))
        infoStack.addArrangedSubview(
            makeInfoBox(label: UILabel().also {
                            $0.text = "장르"
                            $0.textColor = infoColor
                            $0.font = infoFont
                        },
                        main: ivGenre,
                        info: lbGenre)
        )
    }
    
    private func makeInfoBox(label: UIView, main: UIView, info: UIView,
                             boxHeight: CGFloat = 100,
                             lining: Bool = false) -> UIView {
        let sv = UIStackView(arrangedSubviews: [label, main, info]).also { it in
            it.axis = .vertical
            it.alignment = .center
            it.distribution = .fillEqually
            it.setContentHuggingPriority(.required, for: .vertical)
            it.setContentHuggingPriority(.required, for: .horizontal)
            it.setContentCompressionResistancePriority(.required, for: .vertical)
            it.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        return UIView().also { box in
            box.addSubview(sv)
            sv.makeConstraints {
                $0.leadingAnchorConstraintToSuperview(20)
                $0.trailingAnchorConstraintToSuperview(-20)
                $0.topAnchorConstraintToSuperview(10)
                $0.bottomAnchorConstraintToSuperview(-10)
                $0.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
                $0.heightAnchorConstraintTo(boxHeight - 20)
            }
            if lining {
                let line = UIView()
                line.backgroundColor = .systemGray3
                box.addSubview(line)
                line.makeConstraints {
                    $0.widthAnchorConstraintTo(1)
                    $0.topAnchorConstraintToSuperview(20)?.priority = .defaultLow
                    $0.bottomAnchorConstraintToSuperview(-20)?.priority = .defaultLow
                    $0.trailingAnchorConstraintToSuperview()
                }
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
                v.drawOutline()
            }
        }
    }
}
