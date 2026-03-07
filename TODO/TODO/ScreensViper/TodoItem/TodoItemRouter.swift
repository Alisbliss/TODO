//
//  TodoItemPouter.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 06.03.2026.
//

import UIKit

final class TodoItemRouter: TodoItemRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule(with item: TodoItem?) -> UIViewController {
        let view = TodoItemController()
        let interactor = TodoItemInteractor()
        let router = TodoItemRouter()
        let presenter = TodoItemPresenter(item: item, interactor: interactor, router: router)
        
        view.presenter = presenter
        presenter.view = view
        router.viewController = view
        
        return view
    }
    
    func popToRoot() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
}
