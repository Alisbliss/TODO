//
//  TodoItemEntity.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 06.03.2026.
//

import Foundation

struct TodoItem: Sendable, Codable {
    let id: Int
    let todo: String
    let description: String
    let completed: Bool
    let date: String
}
