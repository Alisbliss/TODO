//
//  TodoListInteractor.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 04.03.2026.
//

import Foundation
import CoreData

final class TodoListInteractor: TodoListInteractorInputProtocol {
    weak var presenter: TodoListInteractorOutputProtocol?
    private let persistence = PersistenceController.shared
    private let firstLaunchKey = "isFirstLaunchDone"
    
    func loadData() {
        let isFirstLaunchDone = UserDefaults.standard.bool(forKey: firstLaunchKey)
        
        if !isFirstLaunchDone {
            fetchFromNetwork()
        } else {
            fetchFromCoreData(with: nil)
        }
    }
    
    private func fetchFromNetwork() {
        guard let url = API.todosURL else { return }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(TodoResponse.self, from: data)
                
                await self.saveToCoreData(decodedResponse.todos)
                UserDefaults.standard.set(true, forKey: self.firstLaunchKey)
            } catch {
                print("Fetch/Decode Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveToCoreData(_ items: [TodoItem]) async {
        
        await persistence.container.performBackgroundTask { context in
            
            items.forEach { item in
                let entity = TodoEntity(context: context)
                entity.id = Int64(item.id)
                entity.todo = item.todo
                entity.completed = item.completed
                entity.todoDescription = item.description
                entity.date = item.date
            }
            try? context.save()
            
            DispatchQueue.main.async { [weak self] in
                self?.fetchFromCoreData()
            }
        }
    }
    
    func fetchFromCoreData(with searchText: String? = nil) {
        persistence.container.performBackgroundTask { [weak self] context in
            
            let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            
            if let text = searchText, !text.isEmpty {
                request.predicate = NSPredicate(format: "todo CONTAINS[cd] %@", text)
            }
            
            do {
                let results = try context.fetch(request)
                let todos = results.map { TodoItem(
                    id: Int($0.id),
                    todo: $0.todo ?? "",
                    description: $0.todoDescription ?? "",
                    completed: $0.completed,
                    date: $0.date ?? ""
                )}
                
                DispatchQueue.main.async {
                    self?.presenter?.didFetchTodos(todos)
                }
            } catch {
                print("Core Data Fetch Error: \(error)")
            }
        }
    }
    
    func updateTodoStatus(id: Int, isCompleted: Bool) {
        persistence.container.performBackgroundTask { [weak self] context in
            let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            
            if let entity = try? context.fetch(request).first {
                entity.completed = isCompleted
                try? context.save()
                
                DispatchQueue.main.async {
                    self?.fetchFromCoreData()
                }
            }
        }
    }
    
    func deleteTodo(id: Int) { 
        persistence.container.performBackgroundTask { [weak self] context in
            let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            
            if let entity = try? context.fetch(request).first {
                context.delete(entity)
                try? context.save()
                DispatchQueue.main.async { self?.fetchFromCoreData() }
            }
        }
    }
}
