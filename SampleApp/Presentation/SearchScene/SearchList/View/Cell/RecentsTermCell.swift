//
//  RecentSearchCell.swift
//  AppStoreSample
//
//  Created by hyonsoo han on 2023/09/18.
//

import UIKit
import SwiftUI

final class RecentsTermCell: UITableViewCell {
    static let reuseIdentifier = String(describing: RecentsTermCell.self)
    static let estimatingHeight: CGFloat = 44
    
    private let lbTitle = UILabel()
    
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

extension RecentsTermCell {
    private func setupViews() {
        lbTitle.also { it in
            it.textColor = .systemBlue
            it.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            it.setContentHuggingPriority(.required, for: .vertical)
            it.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            contentView.addSubview(it)
            it.makeConstraints {
                $0.leadingAnchorConstraintToSuperview(20)
                $0.topAnchorConstraintToSuperview(10)
                $0.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -30)
                    .isActive = true
                $0.bottomAnchorConstraintToSuperview(-10)?.priority = .defaultHigh
            }
        }
    }
}

struct RecentSearchCell_Preview: PreviewProvider {
    static var previews: some View {
        let cell1 = RecentsTermCell()
        let cell2 = RecentsTermCell()
        List {
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
