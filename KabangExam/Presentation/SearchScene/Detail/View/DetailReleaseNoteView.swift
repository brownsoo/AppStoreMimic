//
//  DetailReleaseNoteView.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/09/20.
//

import UIKit
import SwiftUI

class DetailReleaseNoteView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    init(text: String) {
        super.init(frame: .zero)
        setupViews()
        self.text = text
    }
    
    var text: String = "" {
        didSet {
            updateLayout()
        }
    }
    
    private let btMore = UIButton(type: .system)
    private let lbDesc = UILabel()
    private let font = UIFont.systemFont(ofSize: 14)
    private let lineSpacing = CGFloat(7)
    private var isMoreOpen = false
    
    private func setupViews() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(lbDesc)
        lbDesc.font = font
        lbDesc.textColor = .label
        lbDesc.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        lbDesc.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        lbDesc.setContentCompressionResistancePriority(.required, for: .vertical)
        lbDesc.setContentHuggingPriority(.required, for: .vertical)
        lbDesc.makeConstraints { it in
            it.leadingAnchorConstraintToSuperview()
            it.trailingAnchorConstraintToSuperview()?.priority = .defaultHigh
            //            it.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            it.topAnchorConstraintToSuperview()
            it.bottomAnchorConstraintToSuperview()?.priority = .defaultHigh
        }
        
        addSubview(btMore)
        btMore.also { it in
            it.setTitle("더 보기", for: .normal)
            it.contentEdgeInsets = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)
            it.addTarget(self, action: #selector(onClickMore), for: .touchUpInside)
        }
        btMore.makeConstraints { it in
            it.trailingAnchorConstraintToSuperview()
            it.bottomAnchorConstraintToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        foot("")
    }
    
    @objc
    private func onClickMore() {
        isMoreOpen = true
        updateLayout()
    }
    
    private func updateLayout() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = self.lineSpacing
        let attrString = NSMutableAttributedString(string: self.text)
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        lbDesc.attributedText = attrString
        let lines = estimateLineCount(text: self.text, width: lbDesc.bounds.width)
        
        if lines > 3 && !isMoreOpen {
            lbDesc.numberOfLines = 3
            btMore.isHidden = self.text.isEmpty
        } else {
            lbDesc.numberOfLines = 0
            btMore.isHidden = true
            
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    private func estimateLineCount(text: String, width: CGFloat) -> CGFloat {
        let label = UILabel()
        label.font = self.font
        label.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = self.lineSpacing
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        let size = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        return max(size.height / label.font.lineHeight, 0)
    }
}


// MARK: --미리보기

struct DetailReleaseNoteView_Preview: PreviewProvider {
    static var previews: some View {
    UIViewPreview {
        DetailReleaseNoteView()
            .also { v in
                v.text = Software.sample().releaseNote ?? ""
            }
        }
    }
}
