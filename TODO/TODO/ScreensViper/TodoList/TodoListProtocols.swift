//
//  TodoListProtocols.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 04.03.2026.
//

import UIKit

protocol TodoListViewProtocol: AnyObject {
    func showTodos(_ todos: [TodoItem])
}

protocol TodoListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapCheckmark(for todoId: Int, isCompleted: Bool)
}

protocol TodoListInteractorInputProtocol: AnyObject {
    func loadData()
    func updateTodoStatus(id: Int, isCompleted: Bool)
}

protocol TodoListInteractorOutputProtocol: AnyObject {
    func didFetchTodos(_ todos: [TodoItem])
}

protocol TodoListRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

