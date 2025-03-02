//
//  ContentView.swift
//  12Days
//
//  Created by Nicholas Rockwell on 2/26/25.
//

import Amplify
import Authenticator
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @StateObject var vm = TodoViewModel()
    
    var body: some View {
        VStack {
            Authenticator { state in
                VStack {
                    Button("Sign out") {
                        Task {
                            await state.signOut()
                        }
                    }
                    Button(action: {
                        Task { await vm.createTodo() }
                    }) {
                        HStack {
                            Text("Add a New Todo")
                            Image(systemName: "plus")
                        }
                    }
                    .accessibilityLabel("New Todo")
                }
            }
            
            List {
                ForEach(vm.todos.indices, id: \.self) { index in
                    TodoRow(vm: vm, todo: $vm.todos[index])
                    Text("Todo: \($vm.todos[index])")
                }
                .onDelete { indexSet in
                    Task { await vm.deleteTodos(indexSet: indexSet) }
                }
                .task {
                    await vm.listTodos()
                }
            }
            Spacer()
            Spacer()
            
            //            NavigationSplitView {
            //                List {
            //                    ForEach(items) { item in
            //                        NavigationLink {
            //                            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
            //                        } label: {
            //                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
            //                        }
            //                    }
            //                    .onDelete(perform: deleteItems)
            //                }
            //                .toolbar {
            //                    ToolbarItem(placement: .navigationBarTrailing) {
            //                        EditButton()
            //                    }
            //                    ToolbarItem {
            //                        Button(action: addItem) {
            //                            Label("Add Item", systemImage: "plus")
            //                        }
            //                    }
            //                }
            //            } detail: {
            //                Text("Select an item")
            //            }
            //        }
            //    }
            //
            //    private func addItem() {
            //        withAnimation {
            //            let newItem = Item(timestamp: Date())
            //            modelContext.insert(newItem)
            //        }
            //    }
            //
            //    private func deleteItems(offsets: IndexSet) {
            //        withAnimation {
            //            for index in offsets {
            //                modelContext.delete(items[index])
            //            }
            //        }
            //    }
        }
        
        //#Preview {
        //    ContentView()
        //        .modelContainer(for: Item.self, inMemory: true)
        //}
    }
}
