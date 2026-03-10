//
//  TodoListInteractorTests.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 10.03.2026.
//

import Testing
import CoreData
import Foundation
@testable import TODO

// MARK: - Mocks
final class MockTodoListPresenter: TodoListInteractorOutputProtocol {
    private var continuation: CheckedContinuation<[TodoItem], Never>?

    func waitForFetch() async -> [TodoItem] {
        await withCheckedContinuation { self.continuation = $0 }
    }

    func didFetchTodos(_ todos: [TodoItem]) {
        continuation?.resume(returning: todos)
        continuation = nil
    }
}

// MARK: - Tests
import Testing
import CoreData
import Foundation
@testable import TODO

@Suite("Todo List Interactor Tests")
@MainActor
struct TodoListInteractorTests {
    let persistence: PersistenceController
    let testInteractor: TodoListInteractor
    let presenter: MockTodoListPresenter

    init() {
        self.persistence = PersistenceController(inMemory: true)
        self.presenter = MockTodoListPresenter()
        self.testInteractor = TodoListInteractor(persistence: persistence)
        self.testInteractor.presenter = presenter
    }

    @Test("Verify data fetching from Core Data")
    func testFetchFromCoreData() async throws {
        let context = persistence.container.newBackgroundContext()
        
        try await context.perform {
            let item = TodoEntity(context: context)
            item.id = 1
            item.todo = "Test Task"
            try context.save()
        }

        testInteractor.fetchFromCoreData()
        let fetchedTodos = await presenter.waitForFetch()

        #expect(fetchedTodos.count == 1)
        #expect(fetchedTodos.first?.todo == "Test Task")
    }

    @Test("Verify todo item deletion")
    func testDeleteTodo() async throws {
        let context = persistence.container.newBackgroundContext()
        
        try await context.perform {
            let item = TodoEntity(context: context)
            item.id = 99
            try context.save()
        }

        testInteractor.deleteTodo(id: 99)
        let fetchedTodos = await presenter.waitForFetch()

        #expect(fetchedTodos.isEmpty)
    }
}
