//
//  Untitled.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 05.03.2026.
//

import UIKit
import SnapKit

final class TodoCheckboxView: UIView {
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().multipliedBy(1.2)
        }
        
        imageView.contentMode = .scaleAspectFit
        update(isCompleted: false)
    }
    
    func update(isCompleted: Bool) {
        let imageName = isCompleted ? "checkmark.circle" : "circle"
        let config = UIImage.SymbolConfiguration(weight: .thin)
        imageView.image = UIImage(systemName: imageName, withConfiguration: config)
        imageView.tintColor = isCompleted ? .customYellow : .grayStroke
    }
}
