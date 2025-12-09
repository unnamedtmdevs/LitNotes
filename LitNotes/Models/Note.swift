//
//  Note.swift
//  KanLit Notes
//

import Foundation

struct Note: Identifiable, Codable, Hashable {
    let id: UUID
    var bookId: UUID
    var bookTitle: String
    var content: String
    var pageNumber: Int?
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        bookId: UUID,
        bookTitle: String,
        content: String,
        pageNumber: Int? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.bookId = bookId
        self.bookTitle = bookTitle
        self.content = content
        self.pageNumber = pageNumber
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

