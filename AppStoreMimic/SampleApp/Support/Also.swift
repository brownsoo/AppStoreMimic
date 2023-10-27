//
//  Also.swift
//  AppStoreMimic
//
//  Created by hyonsoo on 2023/09/17.
//

import Foundation

protocol Also {}

extension Also {
    @discardableResult
    func also(perform thisFn: (Self)->Void) -> Self {
        thisFn(self)
        return self
    }
}

extension NSObject: Also {}
