//
//  TodolistItemCell.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 04.03.2026.
//

import UIKit
import SnapKit

final class TodoListItemCell: UITableViewCell {
    static let identifier = "TodoListItemCell"
    var onCheckmarkTap: (() -> Void)?

    private let checkboxView = TodoCheckboxView()
    private let checkmarkButton = UIButton()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .darkBackground
        
        contentView.addSubview(checkboxView)
        contentView.addSubview(checkmarkButton)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.spacing = 6
        
        checkboxView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.size.equalTo(24)
        }
        
        checkmarkButton.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        checkmarkButton.snp.makeConstraints { make in
            make.center.equalTo(checkboxView)
            make.size.equalTo(44)
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(checkmarkButton.snp.trailing).offset(6)
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(12)
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    @objc private func btnTapped() { onCheckmarkTap?() }
    
    func configure(with item: TodoItem) {
        titleLabel.attributedText = makeAttributedString(
            text: item.todo,
            isStruckthrough: item.completed
        )
        
        descriptionLabel.text = item.description
        dateLabel.text = item.date
        
        checkboxView.update(isCompleted: item.completed)
        
        let mainColor: UIColor = item.completed ? .gray : .customWhite
        titleLabel.textColor = mainColor
        descriptionLabel.textColor = mainColor
    }
    
    private func makeAttributedString(text: String, isStruckthrough: Bool) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: isStruckthrough ? NSUnderlineStyle.single.rawValue : 0
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
}
