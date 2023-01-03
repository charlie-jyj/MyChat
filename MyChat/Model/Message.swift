//
//  Message.swift
//  MyChat
//
//  Created by 정유진 on 2023/01/03.
//

import Foundation

struct Message: Codable {
    var type: String = ""
    var data: Dialogue = Dialogue()
}
