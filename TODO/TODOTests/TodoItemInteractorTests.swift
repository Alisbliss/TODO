//
//  TODOTests.swift
//  TODOTests
//
//  Created by Алеся Афанасенкова on 04.03.2026.
//

import Testing
import CoreData
import Foundation
@testable import TODO

@Suite("Todo Item Interactor Tests")
@MainActor
struct TodoItemInteractorTests {
    
    let persistence: PersistenceController
    let testInteractor: TodoItemInteractor
    
    init() {
        let persistence = PersistenceController(inMemory: true)
        self.persistence = persistence
        self.testInteractor = TodoItemInteractor(persistence: persistence)
    }

    private func waitForSave() async {
        let notifications = NotificationCenter.default.notifications(named: .NSManagedObjectContextDidSave)
        for await _ in notifications {
            return
        }
    }

    @Test("Verify new todo creation")
    func createTodo() async throws {
        let id = 1
        let title = "Test Task"
        
        testInteractor.createTodo(id: id, title: title, description: "Description", date: "10/03/24")
        
        await waitForSave()
        
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        let result = try persistence.container.viewContext.fetch(request)
        
        #expect(result.count == 1)
        #expect(result.first?.todo == title)
    }

    @Test("Verify existing todo update")
    func updateTodo() async throws {
        let id = 10
        testInteractor.createTodo(id: id, title: "Old", description: "Old", date: "01/01/24")
        await waitForSave()
        
        testInteractor.updateTodo(id: id, title: "New", description: "New", date: "02/01/24")
        await waitForSave()
        
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", Int64(id))
        let result = try persistence.container.viewContext.fetch(request)
        
        #expect(result.first?.todo == "New")
    }
}
