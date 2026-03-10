//
//  TodoListRouter.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 04.03.2026.
//

import UIKit

final class TodoListRouter: TodoListRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = TodoListViewController()
        let presenter = TodoListPresenter()
        let interactor = TodoListInteractor()
        let router = TodoListRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        router.viewController = view
        
        return view
    }
    
    func showTodoMenu(for todo: TodoItem) {
        let overlay = TodoDetailOverlayViewController(todo: todo)
        overlay.onDelete = { [weak self] in
            (self?.viewController as? TodoListViewController)?.presenter?.deleteTodo(id: todo.id)
        }
        overlay.onEdit = { [weak self] in
            self?.navigateToEdit(for: todo)
        }
        viewController?.present(overlay, animated: true)
    }
    
    func navigateToEdit(for todo: TodoItem) {
        let editVC = TodoItemRouter.createModule(with: todo)
        viewController?.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func navigateToCreate() {
        let createVC = TodoItemRouter.createModule(with: nil)
        viewController?.navigationController?.pushViewController(createVC, animated: true)
    }
}
