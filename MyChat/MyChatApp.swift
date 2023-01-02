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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
