//
//  History.swift
//  MyChat
//
//  Created by 정유진 on 2023/01/03.
//

import Foundation

struct History: Codable {
    var type: String = ""
    var data: [Dialogue] = []
}
