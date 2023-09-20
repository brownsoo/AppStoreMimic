//
//  FoundationExtentions.swift
//  AppStoreSample
//
//  Created by hyonsoo on 2023/09/19.
//

import Foundation

extension Array {
    func get(at: Int) -> Element? {
        guard at < count else { return nil }
        return self[at]
    }
}
