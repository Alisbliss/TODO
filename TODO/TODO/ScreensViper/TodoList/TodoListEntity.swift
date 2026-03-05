//
//  ToDoEntity.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 04.03.2026.
//

import Foundation

struct TodoResponse: Sendable, Codable {
    let todos: [TodoItem]
}

struct TodoItem: Sendable, Codable {
    let id: Int
    let todo: String
    let description: String
    let completed: Bool
    let date: String
}
