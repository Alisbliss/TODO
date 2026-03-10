//
//  TodoItemInteractor.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 06.03.2026.
//

import CoreData

final class TodoItemInteractor: TodoItemInteractorInputProtocol {
    private let persistence: PersistenceController
    
    init(persistence: PersistenceController = .shared) {
            self.persistence = persistence
        }

    func updateTodo(id: Int, title: String, description: String, date: String) {
        persistence.container.performBackgroundTask { context in
            
            let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %lld", Int64(id))
            
            do {
                if let entity = try context.fetch(request).first {
                    entity.todo = title
                    entity.todoDescription = description
                    entity.date = date
                    
                    if context.hasChanges {
                        try context.save()
                    }
                }
            } catch {
                print("CoreData Error: \(error)")
            }
        }
    }
    
    func createTodo(id: Int, title: String, description: String, date: String) {
        persistence.container.performBackgroundTask { context in
            
            let entity = TodoEntity(context: context)
            entity.id = Int64(id)
            entity.todo = title
            entity.todoDescription = description
            entity.date = date
            entity.completed = false
            
            try? context.save()
        }
    }
}
