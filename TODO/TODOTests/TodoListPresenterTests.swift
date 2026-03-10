//
//  TodoListPresenterTests.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 10.03.2026.
//

import Testing
import UIKit
import Foundation
@testable import TODO

// MARK: - Mocks
final class MockListInteractor: TodoListInteractorInputProtocol {
    var loadDataCalled = false
    var deleteId: Int?
    var updateId: Int?
    
    func loadData() { loadDataCalled = true }
    func updateTodoStatus(id: Int, isCompleted: Bool) { updateId = id }
    func deleteTodo(id: Int) { deleteId = id }
}

final class MockListView: TodoListViewProtocol {
    var shownTodos: [TodoItem] = []
    func showTodos(_ todos: [TodoItem]) { shownTodos = todos }
}

final class MockListRouter: TodoListRouterProtocol {
    static func createModule() -> UIViewController { UIViewController() }
    
    var navigatedToCreate = false
    var showedMenu = false
    var navigatedToEditItem: TodoItem?

    func navigateToCreate() { navigatedToCreate = true }
    func showTodoMenu(for todo: TodoItem) { showedMenu = true }
    func navigateToEdit(for todo: TodoItem) { navigatedToEditItem = todo }
}

// MARK: - Tests
@Suite("Todo List Presenter Tests")
struct TodoListPresenterTests {
    let testPresenter: TodoListPresenter
    let interactor: MockListInteractor
    let view: MockListView
    let router: MockListRouter

    init() {
        testPresenter = TodoListPresenter()
        interactor = MockListInteractor()
        view = MockListView()
        router = MockListRouter()
        
        testPresenter.interactor = interactor
        testPresenter.view = view
        testPresenter.router = router
    }

    @Test("Verify data loading on viewDidLoad")
    func testViewDidLoad() {
        testPresenter.viewDidLoad()
        
        #expect(interactor.loadDataCalled == true)
    }

    @Test("Verify data passing to View")
    func testDidFetchTodos() {
        let items = [TodoItem(id: 1, todo: "Test", description: "", completed: false, date: "")]
        testPresenter.didFetchTodos(items)
        
        #expect(view.shownTodos.count == 1)
        #expect(view.shownTodos.first?.todo == "Test")
    }

    @Test("Verify router call for creation navigation")
    func testNavigateToCreate() {
        testPresenter.didTapCreate()
        
        #expect(router.navigatedToCreate == true)
    }

    @Test("Verify router call for showing menu on long press")
    func testLongPressMenu() {
        let item = TodoItem(id: 1, todo: "Press", description: "", completed: false, date: "")
        testPresenter.didLongPressTodo(item)
        
        #expect(router.showedMenu == true)
    }

    @Test("Verify todo deletion through interactor")
    func testDeleteTodo() {
        let testId = 123
        testPresenter.deleteTodo(id: testId)
        
        #expect(interactor.deleteId == testId)
    }
}
