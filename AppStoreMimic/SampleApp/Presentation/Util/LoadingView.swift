//
//  LoadingView.swift
//  AppStoreMimic
//
//  Created by hyonsoo on 2023/09/18.
//

import UIKit

class LoadingView {

    static var spinner: UIActivityIndicatorView?
    static var spinnerContainer: UIView?
    
    static func show(parent: UIView) {
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(update), name: UIDevice.orientationDidChangeNotification, object: nil)
            
            if spinner == nil {
                let frame = parent.bounds
                let spinner = UIActivityIndicatorView(style: .large)
                let spinnerContainer = UIView(frame: frame)
                spinnerContainer.isOpaque = false
                spinnerContainer.backgroundColor = .black.withAlphaComponent(0.2)
                spinnerContainer.addSubview(spinner)
                spinner.makeConstraints { it in
                    it.centerXAnchorConstraintToSuperview()
                    it.centerYAnchorConstraintToSuperview()
                }
                
                parent.addSubview(spinnerContainer)

                spinner.startAnimating()
                self.spinnerContainer = spinnerContainer
                self.spinner = spinner
            }
        }
    }

    static func hide(didHide: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            guard let spinner = spinner else { return }
            spinner.stopAnimating()
            spinner.removeFromSuperview()
            self.spinnerContainer?.removeFromSuperview()
            self.spinnerContainer = nil
            self.spinner = nil
            didHide?()
        }
    }

    @objc static func update() {
        DispatchQueue.main.async {
            if let superview = spinnerContainer?.superview {
                hide {
                    show(parent: superview)
                }
            }
        }
    }
}

