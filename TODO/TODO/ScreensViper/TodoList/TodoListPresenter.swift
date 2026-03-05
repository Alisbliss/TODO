//
//  TodoListPresenter.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 04.03.2026.
//

final class TodoListPresenter: TodoListPresenterProtocol {
    weak var view: TodoListViewProtocol?
    var interactor: TodoListInteractorInputProtocol?
    
    func viewDidLoad() {
        interactor?.loadData()
    }
    
    func didTapCheckmark(for todoId: Int, isCompleted: Bool) {
        interactor?.updateTodoStatus(id: todoId, isCompleted: isCompleted)
    }
}

extension TodoListPresenter: TodoListInteractorOutputProtocol {
    func didFetchTodos(_ todos: [TodoItem]) {
        view?.showTodos(todos)
    }
}
