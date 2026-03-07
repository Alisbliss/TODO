//
//  TodolistViewController.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 04.03.2026.
//

import UIKit
import SnapKit

final class TodoListViewController: UIViewController, TodoListViewProtocol {
    var presenter: TodoListPresenterProtocol?
    
    private var todos: [TodoItem] = []
    private var filteredTodos: [TodoItem] = []
    
    private var isFiltering: Bool {
        return !(searchBar.text?.isEmpty ?? true)
    }
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    private let customTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Задачи"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .customGray
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "7 задач"
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .customWhite
        return label
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: config), for: .normal)
        button.tintColor = .customYellow
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleCreateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        
        if presenter == nil {
            let presenter = TodoListPresenter()
            let interactor = TodoListInteractor()
            
            self.presenter = presenter
            presenter.view = self
            presenter.interactor = interactor
            interactor.presenter = presenter
        }
        
        setupUI()
        setupLongPressGesture()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .darkBackground
        
        view.addSubview(customTitleLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(bottomBar)
        
        bottomBar.addSubview(countLabel)
        bottomBar.addSubview(createButton)
        
        
        customTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(57)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(56)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(customTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(36)
        }
        
        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-49)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(18)
        }
        
        createButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(13)
            make.width.equalTo(68)
            make.height.equalTo(28)
        }
        
        tableView.register(TodoListItemCell.self, forCellReuseIdentifier: TodoListItemCell.identifier)
        tableView.dataSource = self
        tableView.backgroundColor = .darkBackground
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(bottomBar.snp.top)
        }
    }
    
    private func setupSearchController() {
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .black
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = .customYellow
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .customGray
            textField.layer.cornerRadius = 10
            textField.layer.masksToBounds = true
            textField.borderStyle = .none
            textField.leftView?.tintColor = .gray
        }
        
        let micImage = UIImage(systemName: "mic.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        searchBar.setImage(micImage, for: .bookmark, state: .normal)
        searchBar.showsBookmarkButton = true
    }
    
    func showTodos(_ todos: [TodoItem]) {
        self.todos = todos
        countLabel.text = getTasksString(count: todos.count)
        tableView.reloadData()
    }
    
    private func setupLongPressGesture() {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            longPress.minimumPressDuration = 0.3
            longPress.cancelsTouchesInView = false
        print("кнопка нажата")
            tableView.addGestureRecognizer(longPress)
        }
    
    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                let point = gesture.location(in: tableView)
                if let indexPath = tableView.indexPathForRow(at: point) {
                    let item = isFiltering ? filteredTodos[indexPath.row] : todos[indexPath.row]
                    presenter?.didLongPressTodo(item) // Нужно добавить этот метод в протокол Presenter
                }
            }
        }
    
    @objc private func handleCreateButtonTapped() {
        presenter?.didTapCreate()
    }
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredTodos.count : todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListItemCell.identifier, for: indexPath) as! TodoListItemCell
        let item = isFiltering ? filteredTodos[indexPath.row] : todos[indexPath.row]
        cell.configure(with: item)
        cell.onCheckmarkTap = { [weak self] in
            self?.presenter?.didTapCheckmark(for: item.id, isCompleted: !item.completed)
        }
        return cell
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTodos = todos.filter { item in
            return item.todo.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("Microphone tapped")
    }
}

extension TodoListViewController {
    private func getTasksString(count: Int) -> String {
        let mod10 = count % 10
        let mod100 = count % 100
        
        if mod100 >= 11 && mod100 <= 19 {
            return "\(count) задач"
        }
        
        switch mod10 {
        case 1:
            return "\(count) задача"
        case 2, 3, 4:
            return "\(count) задачи"
        default:
            return "\(count) задач"
        }
    }
}
