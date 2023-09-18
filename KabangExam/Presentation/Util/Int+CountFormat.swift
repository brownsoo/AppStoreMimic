//
//  Int+CountFormat.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/09/18.
//

import Foundation

extension Int {
    func readableCount() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ""
        formatter.maximumFractionDigits = 1
        switch self {
            case _ where self < 1000:
                return "\(self)"
            case 1000..<1_0000:
                let value = (Double(self) / 1000.0)
                if let formed = formatter.string(from: NSNumber(value: value)) {
                    return "\(formed)천"
                }
                return "\(self)"
                
            case 1_0001..<1_0000_0000:
                let value = (Double(self) / 10_000.0)
                if let formed = formatter.string(from: NSNumber(value: value)) {
                    return "\(formed)만"
                }
                return "\(self)"
            default:
                return "1억+"
        }
    }
}
