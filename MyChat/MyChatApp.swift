//
//  MyChatApp.swift
//  MyChat
//
//  Created by 정유진 on 2023/01/02.
//

import SwiftUI

@main
struct MyChatApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        Thread.sleep(forTimeInterval: 3)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
