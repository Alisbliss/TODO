//
//  TodoItem.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 06.03.2026.
//

import UIKit
import SnapKit

final class TodoItemController: UIViewController, TodoItemViewProtocol {
    var presenter: TodoItemPresenterProtocol?
    
    // MARK: - UI Elements
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)?
            .withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.setTitle(" Назад", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.tintColor = .customYellow
        button.setTitleColor(.customYellow, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(handleBackAction), for: .touchUpInside)
        return button
    }()
    
    private let scrollView = UIScrollView()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    private let titleView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 34, weight: .bold)
        tv.textColor = .secondaryLabel
        tv.text = "Название"
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        tv.keyboardAppearance = .dark
        return tv
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let descView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 16, weight: .regular)
        tv.textColor = .secondaryLabel
        tv.text = "Описание"
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        tv.keyboardAppearance = .dark
        return tv
    }()
    
    private lazy var hiddenDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.overrideUserInterfaceStyle = .dark
        picker.locale = Locale(identifier: "ru_RU")
        picker.backgroundColor = .black
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()
    
    private let hiddenTextField: UITextField = {
        let tf = UITextField()
        tf.isHidden = true
        return tf
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        titleView.delegate = self
        descView.delegate = self
        setupLayout()
        setupDatePickerLogic()
        setDefaultDate()
        presenter?.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    private func setupLayout() {
        [backButton, scrollView, hiddenTextField].forEach {
            view.addSubview($0)
        }
        scrollView.addSubview(contentStack)
        [titleView, dateLabel, descView].forEach { contentStack.addArrangedSubview($0) }
        
        contentStack.setCustomSpacing(16, after: dateLabel)
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(54)
            make.leading.equalToSuperview()
            make.width.equalTo(81)
            make.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20))
            make.width.equalTo(scrollView.snp.width).offset(-40)
        }
        
        titleView.setContentCompressionResistancePriority(.required, for: .vertical)
        dateLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        descView.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    private func setupDatePickerLogic() {
        hiddenTextField.inputView = hiddenDatePicker
        let dateTap = UITapGestureRecognizer(target: self, action: #selector(handleDateTap))
        dateLabel.addGestureRecognizer(dateTap)
    }
    
    private func setDefaultDate() {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy"
        let today = Date()
        hiddenDatePicker.date = today
        dateLabel.text = df.string(from: today)
    }
    
    // MARK: - Actions
    @objc private func handleDateTap() {
        view.endEditing(true)
        hiddenTextField.becomeFirstResponder()
    }
    
    @objc private func dateChanged() {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy"
        dateLabel.text = df.string(from: hiddenDatePicker.date)
    }
    
    @objc private func dismissPicker() {
        view.endEditing(true)
    }
    @objc private func handleBackAction() {
        
        let finalTitle = (titleView.textColor == .secondaryLabel) ? "" : titleView.text
        let finalDescription = (descView.textColor == .secondaryLabel) ? "" : descView.text
        
        presenter?.didTapSave(
            title: finalTitle ?? "",
            description: finalDescription ?? "",
            date: hiddenDatePicker.date
        )
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Protocol Methods
    func displayTodo(_ item: TodoItem) {
        if !item.todo.isEmpty {
            titleView.text = item.todo
            titleView.textColor = .customWhite
        } else {
            titleView.text = "Название"
            titleView.textColor = .secondaryLabel
        }
        
        if !item.description.isEmpty {
            descView.text = item.description
            descView.textColor = .customWhite
        } else {
            descView.text = "Описание"
            descView.textColor = .secondaryLabel
        }
        
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy"
        
        if !item.date.isEmpty, let date = df.date(from: item.date) {
            hiddenDatePicker.date = date
            dateLabel.text = item.date
        } else {
            setDefaultDate()
        }
    }
}

extension TodoItemController: UITextViewDelegate {
    // MARK: - UITextViewDelegate (Placeholder)
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .secondaryLabel
            textView.text = (textView === titleView) ? "Название" : "Описание"
        }
    }
}
