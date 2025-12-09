//
//  Book.swift
//  LitNotes
//
//  Created by Simon Bakhanets on 09.12.2025.
//

import Foundation

struct Book: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var author: String
    var description: String
    var coverImage: String
    var genre: String
    var rating: Double
    var totalPages: Int
    var currentPage: Int
    var isTrending: Bool
    var publishedYear: Int
    
    init(
        id: UUID = UUID(),
        title: String,
        author: String,
        description: String,
        coverImage: String,
        genre: String,
        rating: Double,
        totalPages: Int,
        currentPage: Int = 0,
        isTrending: Bool = false,
        publishedYear: Int
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.description = description
        self.coverImage = coverImage
        self.genre = genre
        self.rating = rating
        self.totalPages = totalPages
        self.currentPage = currentPage
        self.isTrending = isTrending
        self.publishedYear = publishedYear
    }
    
    var progress: Double {
        guard totalPages > 0 else { return 0 }
        return Double(currentPage) / Double(totalPages)
    }
}

