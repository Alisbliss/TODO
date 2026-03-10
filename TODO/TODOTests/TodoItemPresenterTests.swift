//
//  Untitled.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 10.03.2026.
//

import Testing
import Foundation
@testable import TODO

// MARK: - Mocks
final class MockTodoItemInteractor: TodoItemInteractorInputProtocol {
    var createCalled = false
    var lastTitle = ""
    func createTodo(id: Int, title: String, description: String, date: String) {
        createCalled = true
        lastTitle = title
    }
    func updateTodo(id: Int, title: String, description: String, date: String) {}
}

final class MockTodoItemRouter: TodoItemRouterProtocol {
    var popCalled = false
    func popToRoot() { popCalled = true }
}

// MARK: - Tests
@Suite("Todo Item Presenter Tests")
struct TodoItemPresenterTests {
    
    @Test("Verify replacing empty title with a placeholder")
    func testPlaceholderTitle() {
        let interactor = MockTodoItemInteractor()
        let router = MockTodoItemRouter()
        let testPresenter = TodoItemPresenter(item: nil, interactor: interactor, router: router)
        
        testPresenter.didTapSave(title: "   ", description: "Description exists", date: Date())
        
        #expect(interactor.createCalled == true)
        #expect(interactor.lastTitle == "Новая задача")
        #expect(router.popCalled == true)
    }
    
    @Test("Verify exit without saving when fields are empty")
    func testEmptyExit() {
        let interactor = MockTodoItemInteractor()
        let router = MockTodoItemRouter()
        let sut = TodoItemPresenter(item: nil, interactor: interactor, router: router)
        
        sut.didTapSave(title: "", description: "", date: Date())
        
        #expect(interactor.createCalled == false)
        #expect(router.popCalled == true)
    }
}
