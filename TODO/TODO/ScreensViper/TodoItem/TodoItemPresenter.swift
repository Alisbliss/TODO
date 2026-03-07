//
//  TodoItemPresenter.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 06.03.2026.
//

import Foundation

final class TodoItemPresenter: TodoItemPresenterProtocol {
    weak var view: TodoItemViewProtocol?
    private let interactor: TodoItemInteractorInputProtocol
    private let router: TodoItemRouterProtocol
    private let item: TodoItem?
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy"
        return df
    }()
    
    init(item: TodoItem?, interactor: TodoItemInteractorInputProtocol, router: TodoItemRouterProtocol) {
        self.item = item
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        if let item = item {
            view?.displayTodo(item)
        }
    }
    
    func didTapSave(title: String, description: String, date: Date) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDesc = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedTitle.isEmpty && trimmedDesc.isEmpty {
            router.popToRoot()
            return
        }
        
        let finalTitle = trimmedTitle.isEmpty ? "Новая задача" : trimmedTitle
        let dateString = dateFormatter.string(from: date)
        
        if let existingItem = item {
            interactor.updateTodo(id: existingItem.id,
                                  title: finalTitle,
                                  description: trimmedDesc,
                                  date: dateString)
        } else {
            let newId = Int(Date().timeIntervalSince1970)
            interactor.createTodo(id: newId,
                                  title: finalTitle,
                                  description: trimmedDesc,
                                  date: dateString)
        }
        router.popToRoot()
    }
}
