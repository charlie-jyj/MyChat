//
//  ChatBoard.swift
//  MyChat
//
//  Created by 정유진 on 2023/01/02.
//

import SwiftUI

struct ChatBoard: View {
    
    
    @State var currentMessage: String = ""
    @Binding var username: String
    
    @StateObject var websocket = WebSocketManager.shared
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: true) {
                Text(websocket.history)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
           Spacer()
            HStack{
                TextField("chat", text: $currentMessage)
                Button(action: {
                    WebSocketManager.shared.sendMessage(currentMessage)
                    currentMessage = ""
                }){
                    Label("send", systemImage: "pencil")
                }
            }
        }
        .padding(EdgeInsets(top: 100,
                            leading: 40,
                            bottom: 10,
                            trailing: 40))
        .onAppear {
            let _ = WebSocketManager.shared
                .setUser(_user: User(userName: username))
                .setupWebSocket()
        }
        .onDisappear {
            WebSocketManager.shared.disconnect()
        }
    }
}

struct ChatBoard_Previews: PreviewProvider {
    static var previews: some View {
        ChatBoard(username: .constant("yujin"))
    }
}
