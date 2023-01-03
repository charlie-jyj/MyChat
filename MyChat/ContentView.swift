//
//  ContentView.swift
//  MyChat
//
//  Created by 정유진 on 2023/01/02.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    private enum Field: Int, CaseIterable {
        case username
    }
    
    @State var username: String = ""
    @State var isChatBoardAppear: Bool = false
    @FocusState private var focusedField: Field?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Hello, \(username)")
                HStack {
                    TextField("Username", text: $username)
                        .focused($focusedField, equals: .username)
                        .sheet(isPresented: $isChatBoardAppear) {
                            ChatBoard(username: $username)
                        }
                    Button(action: { isChatBoardAppear = !isChatBoardAppear }) {
                        Label("register", systemImage: "pencil")
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done") {
                        focusedField = nil
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }// end of body
    

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
