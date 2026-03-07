//
//  UIColor + Extension.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 04.03.2026.
//

import UIKit

import UIKit

extension UIColor {
 
    static let customYellow = UIColor(hex: "#FED702")
    static let customGray = UIColor(hex: "#272729")
    static let customWhite = UIColor(hex: "#F4F4F4")
    static let darkBackground = UIColor(hex: "#040404")
    static let grayStroke = UIColor(hex: "#4D555E")
    static let customLightGray = UIColor(hex: "#EDEDED").withAlphaComponent(0.8)
    static let customRed = UIColor(hex: "#D70015")
    static let lineBorder = UIColor(hex: "#4D555E80").withAlphaComponent(0.5)

    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

