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
    
    private let btMore = UIButton(type: .system)
    private let lbDesc = UILabel()
    private let lbVersion = UILabel()
    private let font = UIFont.systemFont(ofSize: 16)
    private let lineSpacing = CGFloat(7)
    private var isMoreOpen = false
    private var text = ""
    private var version = ""
    
    private func setupViews() {
        // self.translatesAutoresizingMaskIntoConstraints = false
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        self.setContentHuggingPriority(.required, for: .vertical)
        
        let line = UIView()
        line.backgroundColor = .systemGray3
        addSubview(line)
        line.makeConstraints { it in
            it.heightAnchorConstraintTo(1)
            it.topAnchorConstraintToSuperview()
            it.leadingAnchorConstraintToSuperview()
            it.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        }
        
        let lbTitle = UILabel()
        lbTitle.text = "새로운 기능"
        lbTitle.font = .boldSystemFont(ofSize: 24)
        addSubview(lbTitle)
        lbTitle.makeConstraints { it in
            it.topAnchorConstraintToSuperview(10)
            it.leadingAnchorConstraintToSuperview()
        }
        
        lbVersion.font = .systemFont(ofSize: 16)
        lbVersion.textColor = .secondaryLabel
        addSubview(lbVersion)
        lbVersion.makeConstraints { it in
            it.topAnchorConstraintTo(lbTitle.bottomAnchor, constant: 4)
            it.leadingAnchorConstraintToSuperview()
        }
        
        
        addSubview(lbDesc)
        lbDesc.font = font
        lbDesc.textColor = .label
        lbDesc.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        lbDesc.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        lbDesc.makeConstraints { it in
            it.leadingAnchorConstraintToSuperview()
            it.trailingAnchorConstraintToSuperview()?.priority = .defaultHigh
            it.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            it.topAnchorConstraintTo(lbVersion.bottomAnchor, constant: 10)
            it.bottomAnchorConstraintToSuperview(-10)?.priority = .init(999)
        }
        
        addSubview(btMore)
        btMore.also { it in
            it.setTitle("더 보기", for: .normal)
            it.contentEdgeInsets = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)
            it.backgroundColor = .tertiarySystemBackground
            it.layer.cornerRadius = 8
            it.layer.masksToBounds = true
            it.addTarget(self, action: #selector(onClickMore), for: .touchUpInside)
        }
        btMore.makeConstraints { it in
            it.trailingAnchorConstraintToSuperview()
            it.bottomAnchorConstraintToSuperview()
        }
    }
    
    @objc
    private func onClickMore() {
        isMoreOpen = true
        updateLayout()
    }
    
    func update(version: String, note: String) {
        self.version = version
        self.text = note
        updateLayout()
    }
    
    private func updateLayout() {
        
        lbVersion.text = "버전 \(self.version)"
        
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
        VStack {
            UIViewPreview {
                DetailReleaseNoteView()
                    .also { v in
                        v.update(version: "1.0.0",
                                 note: "● 전월세보증금 대출 갈아타기 출시 (9/13 오픈)\n- 기존 대출 해지 없이 새로운 전월세보증금 대출을 조회하고 갈아탈 수 있어요.\n- 살고 있는 집의 보증금이 오르거나 이사를 가는 경우에도 신청이 가능해요.\n\n● 사용성 개선\n- 더욱 편리한 서비스 제공을 위해 기능 개선 및 불편점 해소 작업도 함께 진행했어요.")
                    }
            }
            Spacer()
        }
    }
}
