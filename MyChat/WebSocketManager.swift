//
//  WebSocketManager.swift
//  MyChat
//
//  Created by 정유진 on 2023/01/03.
//

import Foundation
import Combine
import Starscream


class WebSocketManager: ObservableObject  {
    
    
    public static let shared = WebSocketManager()
    private var socket: WebSocket?
    private var user: User?
    
    @Published var isConnected: Bool = false
    @Published var history: String = ""
    @Published var data: Data = Data()

    // Builder
    public func setUser(_user: User) -> WebSocketManager {
        user = _user
        return self
    }
    
    public func setupWebSocket() -> WebSocketManager {
        guard let url = URL(string: "ws://192.168.151.20:1337/") else { return self }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
        return self
    }
    
    // API
    public func sendMessage(_ message: String) {
        socket?.write(string: message)
    }
    
    public func disconnect() {
        print("websocket disconnect")
        socket?.disconnect()
        socket?.delegate = nil
    }
    
    private func publishMessage(type: String, data messageData: Message) {
        let messageString = "\(messageData.data.author):\(messageData.data.text)"
        self.history = self.history + messageString
    }
    
    private func publishHistory(type: String, data historyData: History) {
        var historyString = ""
        historyData.data
            .sorted(by: {$0.time < $1.time})
            .forEach { (dialogue) in
            historyString += "\(dialogue.author):\(dialogue.text)\n"
        }
        self.history = historyString
    }
    
}

extension WebSocketManager: WebSocketDelegate {
    
    
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
        switch event {
        case .connected(let headers):
            guard let userName = user?.userName else { return }
            client.write(string: userName)
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let text):
            guard let textData = text.data(using: .utf16),
                  let jsonData = try? JSONSerialization.jsonObject(with: textData, options: []),
                  let jsonDict = jsonData as? NSDictionary,
                  let messageType = jsonDict["type"] as? String
            else { return }
            
            if messageType == "message",
               let messageData = try? JSONDecoder().decode(Message.self, from: textData) {
                publishMessage(type: messageType, data: messageData)
            }
            
            if messageType == "history",
               let historyData = try? JSONDecoder().decode(History.self, from: textData) {
                publishHistory(type: messageType, data: historyData)
            }
            
            print("Received Text: \(text)")
        case .binary(let data):
            self.data = data
            print("Received data: \(data)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            print("websocket is cancelled")
        case .error(let error):
            print("websocket is error: \(String(describing: error?.localizedDescription))")
        }
    }
    
    
}

