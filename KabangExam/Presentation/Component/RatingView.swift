//
//  RatingView.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/09/19.
//

import UIKit
import SwiftUI

class RatingView: UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private var track = UILabel()
    private let maskLayer = CAShapeLayer()
    private var _rate: CGFloat = 0
    /// 0~5
    var rate: CGFloat {
        get {
            _rate
        }
        set {
            _rate = max(0, min(5.0, newValue))
            if superview != nil {
                setNeedsLayout()
            }
        }
    }
    
    init() {
        super.init(frame: CGRect())
        setupViews()
    }
    
    init(progress: CGFloat) {
        super.init(frame: CGRect())
        self.rate = progress
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        debugPrint(track.bounds)
        maskLayer.path = UIBezierPath(
            rect: CGRect(origin: .zero, size: CGSize(width: track.bounds.width * (rate / 5), height: track.bounds.height))
        ).cgPath
    }
}

extension RatingView {
    private func setupViews() {
        self.translatesAutoresizingMaskIntoConstraints = false
//        self.setContentHuggingPriority(.required, for: .vertical)
//        self.setContentHuggingPriority(.required, for: .horizontal)
//        self.setContentCompressionResistancePriority(.required, for: .vertical)
//        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        track = makeStarLabel(filled: false)
        addSubview(track)
//        track.backgroundColor = .yellow
        track.font = .systemFont(ofSize: 12)
        track.textColor = .secondaryLabel
        track.makeConstraints { it in
//            it.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//            it.setContentHuggingPriority(.defaultHigh, for: .vertical)
//            it.setContentCompressionResistancePriority(.required, for: .horizontal)
//            it.setContentCompressionResistancePriority(.required, for: .vertical)
            it.edgesConstraintToSuperview(edges: .vertical)
            it.leadingAnchorConstraintToSuperview()?.priority = .init(999)
            it.trailingAnchorConstraintToSuperview()?.priority = .init(999)
        }
        
        let cover = makeStarLabel(filled: true)
        addSubview(cover)
        cover.font = .systemFont(ofSize: 12)
        cover.textColor = .secondaryLabel
        cover.makeConstraints { it in
            it.edgesConstraintTo(track.safeAreaLayoutGuide, edges: .all)
        }
        
        maskLayer.fillColor = UIColor.red.cgColor
        maskLayer.lineWidth = 0
        cover.layer.mask = maskLayer
        
    }
    
    private func makeStarLabel(filled: Bool) -> UILabel {
        let sfSymbol = filled ? "star.fill" : "star"
        let lb = UILabel()
        let attrString = NSMutableAttributedString()
        for _ in 0..<5 {
            if let star = UIImage(systemName: sfSymbol) {
                let image = NSTextAttachment(image: star)
                attrString.append(NSAttributedString(attachment: image))
            } else {
                attrString.append(NSAttributedString(string: "*"))
            }
        }
        lb.attributedText = attrString
        return lb
    }
}



struct RatingView_Preview: PreviewProvider {
    static let v = RatingView().also {
        $0.backgroundColor = .cyan
    }
    static var previews: some View {
        VStack {
            UIViewPreview {
                v
            }.onAppear {
                v.rate = 1
            }
            
            UIViewPreview {
                RatingView(progress: 2.5)
            }
            
            UIViewPreview {
                RatingView()
            }
            Spacer()
        }
        .previewDevice(.none)
        .previewLayout(.sizeThatFits)
    }
    
}
