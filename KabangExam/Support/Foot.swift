//
//  Foot.swift
//  KabangExam
//
//  Created by hyonsoo on 2023/09/17.
//

import Foundation

func foot(_ msg: String? = nil, filename: String = #file, funcName: String = #function) {
    print("⚽️** \(Thread.current.isMainThread ? "main" : "\(Thread.current.self)") \(filename.components(separatedBy: "/").last ?? filename) \t\(funcName) \(msg ?? "")")
}
