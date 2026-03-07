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
