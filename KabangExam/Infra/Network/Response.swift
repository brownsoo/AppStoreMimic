//
//  Response.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/08/31.
//

import Foundation

protocol Response {
    var status: Int { get }
    var data: Data? { get }
}
