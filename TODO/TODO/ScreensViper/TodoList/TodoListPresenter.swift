//
//  TodoListPresenter.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 04.03.2026.
//

final class TodoListPresenter: TodoListPresenterProtocol {
    weak var view: TodoListViewProtocol?
    var interactor: TodoListInteractorInputProtocol?
    var router: TodoListRouterProtocol?
    
    func viewDidLoad() {
        view?.showLoader(true)
        interactor?.loadData()
    }
    
    func didTapCheckmark(for todoId: Int, isCompleted: Bool) {
        interactor?.updateTodoStatus(id: todoId, isCompleted: isCompleted)
    }
    
    func didLongPressTodo(_ todo: TodoItem) {
        router?.showTodoMenu(for: todo)
    }
    
    func didTapCreate() {
        router?.navigateToCreate()
    }
    
    func deleteTodo(id: Int) {
        interactor?.deleteTodo(id: id)
    }
}

extension TodoListPresenter: TodoListInteractorOutputProtocol {
    func didFetchTodos(_ todos: [TodoItem]) {
        view?.showLoader(false)
        view?.showTodos(todos)
    }
}
