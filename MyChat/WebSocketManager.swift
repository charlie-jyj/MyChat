//
//  WebSocket.swift
//  MyChat
//
//  Created by 정유진 on 2023/01/03.
//

import Foundation
import Starscream

struct User {
    let userName: String
}

class WebSocketManager {
    public static let shared = WebSocketManager()
    private var socket: WebSocket?
    private var user: User?
    
    public func setUser(_user: User) -> WebSocketManager {
        user = _user
        return self
    }
    
    public func setWebSocket() -> WebSocketManager {
        guard let url = URL(string: "ws://localhost:1337/") else { return self }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        return self
    }
}

