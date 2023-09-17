//
//  Response.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/09/17.
//

import Foundation

protocol Response {
    var status: Int { get }
    var data: Data? { get }
}
