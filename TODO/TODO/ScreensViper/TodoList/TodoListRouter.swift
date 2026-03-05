//
//  TodoListRouter.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 04.03.2026.
//

import UIKit

final class TodoListRouter: TodoListRouterProtocol {
    static func createModule() -> UIViewController {
        let view = TodoListViewController()
        let presenter = TodoListPresenter()
        let interactor = TodoListInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}
