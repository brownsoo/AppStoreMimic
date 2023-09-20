//
//  CandidateSearchCell.swift
//  AppStoreSample
//
//  Created by hyonsoo han on 2023/09/18.
//

import UIKit
import SwiftUI

final class CandidateSearchCell: UITableViewCell {
    static let reuseIdentifier = String(describing: CandidateSearchCell.self)
    static let estimatingHeight: CGFloat = 44
    
    private let btTrans = UIButton()
    private let lbTitle = UILabel()
    private let ivIcon = UIImageView(image: UIImage(systemName: "magnifyingglass")?
        .withTintColor(UIColor.systemGray2)
        .withRenderingMode(.alwaysOriginal)
    )
    
    weak var delegate: ResultItemCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func fill(with title: String) {
        lbTitle.text = title
    }
}

extension CandidateSearchCell {
    
    @objc
    private func didClick() {
        delegate?.didClickCandidateItemCell(text: lbTitle.text ?? "")
    }
    
    private func setupViews() {
        btTrans.also { it in
            it.setBackgroundImage(UIImage().solid(.systemGray6, width: 10, height: 10).resizableImage(withCapInsets: .zero), for: .highlighted)
            it.addTarget(self, action: #selector(didClick), for: .touchUpInside)
            contentView.addSubview(it)
            it.makeConstraints {
                $0.edgesConstraintToSuperview(edges: .all)
            }
        }
        
        ivIcon.also { it in
            contentView.addSubview(it)
            it.makeConstraints {
                $0.sizeAnchorConstraintTo(20)
                $0.leadingAnchorConstraintToSuperview(20)
                $0.topAnchorConstraintToSuperview(10)
                $0.bottomAnchorConstraintToSuperview(-10)?.priority = .init(999)
            }
        }
        
        lbTitle.also { it in
            it.textColor = .label
            it.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            it.setContentHuggingPriority(.required, for: .vertical)
            it.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            contentView.addSubview(it)
            it.makeConstraints {
                $0.leadingAnchorConstraintTo(ivIcon.trailingAnchor, constant: 10)
                $0.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -30)
                    .isActive = true
                $0.topAnchorConstraintToSuperview(10)?.priority = .defaultHigh
                $0.bottomAnchorConstraintToSuperview(-10)?.priority = .defaultHigh
                $0.centerYAnchorConstraintTo(ivIcon)
            }
        }
    }
}

struct CandidateSearchCell_Preview: PreviewProvider {
    static var previews: some View {
        let cell1 = CandidateSearchCell()
        let cell2 = CandidateSearchCell()
        VStack {
            UIViewPreview {
                cell1
            }.onAppear { cell1.fill(with: "카카오뱅크") }
            UIViewPreview {
                cell2
            }.onAppear { cell2.fill(with: "카카오뱅크2") }
        }
        .listStyle(PlainListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
