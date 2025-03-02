//
//  TodoViewModel.swift
//  12Days
//
//  Created by Nicholas Rockwell on 2/28/25.
//

import Foundation
import Amplify
import SwiftUI

@MainActor
class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    
    init() {
        Task {
            print("TodoViewModel initialized, fetching todos...")
            await listTodos()
        }
    }
    
    func createTodo() async {
        let creationTime = Temporal.DateTime.now()
        let todo = Todo(
            content: "Random Todo \(creationTime.iso8601String)",
            isDone: false,
            createdAt: creationTime,
            updatedAt: creationTime
        )
        do {
            let result = try await Amplify.API.mutate(request: .create(todo))
            switch result {
            case .success(let todo):
                print("Successfully created todo: \(todo)")
                todos.append(todo)
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to create todo: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func listTodos() async {
        print("Starting listTodos()...")
        
        let request = GraphQLRequest<Todo>.list(Todo.self)
        do {
            let result = try await Amplify.API.query(request: request)
            
            switch result {
            case .success(let todosList):
                let extractedTodos = todosList.elements.map { todo in
                    Todo(id: todo.id,
                         content: todo.content,
                         isDone: todo.isDone,
                         createdAt: todo.createdAt,
                         updatedAt: todo.updatedAt)
                }
                print("Successfully retrieved \(extractedTodos.count) todos: \(extractedTodos)")
                
                DispatchQueue.main.async {
                    self.todos = []  // 🔥 Force UI update
                    self.todos = extractedTodos
                }
            case .failure(let error):
                print("Query failed: \(error.errorDescription)")
            }
        } catch {
            print("Unexpected error in listTodos(): \(error)")
        }
    }
    
    func deleteTodos(indexSet: IndexSet) async {
        for index in indexSet {
            do {
                let todo = todos[index]
                let result = try await Amplify.API.mutate(request: .delete(todo))
                switch result {
                case .success(let todo):
                    print("Successfully deleted todo: \(todo)")
                    todos.remove(at: index)
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            } catch let error as APIError {
                print("Failed to deleted todo: ", error)
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }
    
    func updateTodo(todo: Todo) async {
        do {
            let result = try await Amplify.API.mutate(request: .update(todo))
            switch result {
            case .success(let todo):
                print("Successfully updated todo: \(todo)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to updated todo: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}
