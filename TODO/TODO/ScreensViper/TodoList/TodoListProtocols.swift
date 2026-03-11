//
//  TodoListProtocols.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 04.03.2026.
//

import UIKit

protocol TodoListViewProtocol: AnyObject {
    func showTodos(_ todos: [TodoItem])
    func showLoader(_ show: Bool)
}

protocol TodoListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapCheckmark(for todoId: Int, isCompleted: Bool)
    func didLongPressTodo(_ todo: TodoItem)
    func deleteTodo(id: Int)
    func didTapCreate()
}

protocol TodoListInteractorInputProtocol: AnyObject {
    func loadData()
    func updateTodoStatus(id: Int, isCompleted: Bool)
    func deleteTodo(id: Int)
}

protocol TodoListInteractorOutputProtocol: AnyObject {
    func didFetchTodos(_ todos: [TodoItem])
}

protocol TodoListRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func showTodoMenu(for todo: TodoItem)
    func navigateToEdit(for todo: TodoItem) 
    func navigateToCreate()
}

