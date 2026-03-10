//
//  Untitled.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 06.03.2026.
//

import UIKit
import SnapKit

final class TodoDetailOverlayViewController: UIViewController {
    
    var onDelete: (() -> Void)?
    var onEdit: (() -> Void)?
    private let todo: TodoItem

    // MARK: - UI Elements
    private lazy var blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        let overlay = UIView()
        overlay.backgroundColor = UIColor(hex: "#040404").withAlphaComponent(0.5)
        view.contentView.addSubview(overlay)
        overlay.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private let taskContainer: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .customGray
        stack.layer.cornerRadius = 12
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        return label
    }()

    private let customMenuStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.backgroundColor = .customLightGray
        stack.layer.cornerRadius = 12
        stack.alignment = .fill
        stack.spacing = 0
        stack.clipsToBounds = true
        return stack
    }()

    init(todo: TodoItem) {
        self.todo = todo
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMenuButtons()
        configureData()
    }

    private func setupUI() {
        [blurEffectView, taskContainer, customMenuStack].forEach {
            view.addSubview($0)
        }
        
        [titleLabel, descriptionLabel, dateLabel].forEach { taskContainer.addArrangedSubview($0) }
        taskContainer.isLayoutMarginsRelativeArrangement = true
        taskContainer.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
            
        
        blurEffectView.snp.makeConstraints { $0.edges.equalToSuperview() }

        taskContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(368)
            make.centerX.equalToSuperview()
            make.width.equalTo(320)
        }

        customMenuStack.snp.makeConstraints { make in
            make.top.equalTo(taskContainer.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(254)
        }
    }

    private func setupMenuButtons() {
        let items: [(String, String, UIColor, Selector)] = [
            ("Редактировать", "editButton", .darkBackground, #selector(handleEdit)),
            ("Поделиться", "shareButton", .darkBackground, #selector(dismissSelf)),
            ("Удалить", "trashButton", .customRed, #selector(handleDelete))
        ]

        for (index, item) in items.enumerated() {
            var config = UIButton.Configuration.plain()
            config.baseForegroundColor = item.2
            var titleAttr = AttributedString(item.0)
            titleAttr.font = .systemFont(ofSize: 17, weight: .regular)
            config.attributedTitle = titleAttr
            config.image = UIImage(named: item.1)
            config.imagePlacement = .trailing
            config.imagePadding = 0
            config.contentInsets = .zero
            
            let btn = UIButton(configuration: config)
            btn.backgroundColor = .clear
            btn.contentHorizontalAlignment = .fill
            
                btn.titleLabel?.numberOfLines = 1
                btn.titleLabel?.lineBreakMode = .byTruncatingTail
            btn.configurationUpdateHandler = { button in
                button.alpha = button.isHighlighted ? 0.5 : 1.0
            }
            btn.addTarget(self, action: item.3, for: .touchUpInside)
            
            customMenuStack.addArrangedSubview(btn)
            
            btn.snp.makeConstraints { make in
                make.height.equalTo(44)
                make.width.equalTo(254)
            }
            
            btn.imageView?.snp.makeConstraints { make in
                make.size.equalTo(16)
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(16)
            }
            
            btn.titleLabel?.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.centerY.equalToSuperview()
                make.trailing.equalTo(btn.imageView!.snp.leading).offset(-10)
            }

            if index > 0 {
                let line = UIView()
                line.backgroundColor = .lineBorder
                btn.addSubview(line)
                
                line.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.leading.trailing.equalToSuperview()
                    make.height.equalTo(0.5)
                }
            }
        }
    }
    
    private func configureData() {
        titleLabel.text = todo.todo
        descriptionLabel.text = todo.description
        dateLabel.text = todo.date
    }

    @objc private func handleEdit() {
        dismiss(animated: true) { self.onEdit?() }
    }

    @objc private func handleDelete() {
        dismiss(animated: true) { self.onDelete?() }
    }

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
}
