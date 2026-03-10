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
    
    enum CodingKeys: String, CodingKey {
        case id, todo, completed
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        todo = try container.decodeIfPresent(String.self, forKey: .todo) ?? ""
        completed = try container.decodeIfPresent(Bool.self, forKey: .completed) ?? false
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        date = formatter.string(from: Date())
        description = ""
    }
    
    init(id: Int, todo: String, description: String, completed: Bool, date: String) {
        self.id = id
        self.todo = todo
        self.description = description
        self.completed = completed
        self.date = date
    }
}
