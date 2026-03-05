//
//  Untitled.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 05.03.2026.
//

import UIKit
import SnapKit

final class TodoCheckboxView: UIView {
    private let circleImageView = UIImageView()
    private let tickImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        addSubview(circleImageView)
        addSubview(tickImageView)

        circleImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tickImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.6)
        }
        
        circleImageView.contentMode = .scaleAspectFit
        tickImageView.contentMode = .scaleAspectFit
      
        circleImageView.image = UIImage(named: "customCircle")?.withRenderingMode(.alwaysTemplate)
        tickImageView.image = UIImage(named: "customTick")?.withRenderingMode(.alwaysTemplate)
        
        circleImageView.tintColor = .grayStroke
        tickImageView.tintColor = .customYellow
    }

    func update(isCompleted: Bool) {
        
        tickImageView.isHidden = !isCompleted
        
        circleImageView.tintColor = isCompleted ? .customYellow : .grayStroke
        tickImageView.tintColor = .customYellow
    }
}
