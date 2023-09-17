//
//  NetworkResponse.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/08/31.
//

import Foundation

struct NetworkResponse: Response {
    var status: Int
    var data: Data?
}
