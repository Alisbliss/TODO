//
//  TodoItemProtocols.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 06.03.2026.
//

import UIKit

// View -> Presenter
protocol TodoItemPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSave(title: String, description: String, date: Date)
}

// Presenter -> View
protocol TodoItemViewProtocol: AnyObject {
    func displayTodo(_ item: TodoItem)
}

// Presenter -> Interactor
protocol TodoItemInteractorInputProtocol: AnyObject {
    func updateTodo(id: Int, title: String, description: String, date: String)
    func createTodo(id: Int, title: String, description: String, date: String)
}

// Presenter -> Router
protocol TodoItemRouterProtocol: AnyObject {
    func popToRoot()
}
