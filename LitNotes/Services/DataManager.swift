//
//  DataManager.swift
//  LitNotes
//
//  Created by Simon Bakhanets on 09.12.2025.
//

import Foundation

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var books: [Book] = []
    @Published var notes: [Note] = []
    @Published var userPreferences: UserPreferences = UserPreferences()
    
    private let booksKey = "saved_books"
    private let notesKey = "saved_notes"
    private let preferencesKey = "user_preferences"
    
    private init() {
        loadData()
        if books.isEmpty {
            loadSampleBooks()
        }
    }
    
    // MARK: - Books Management
    
    func addBook(_ book: Book) {
        books.append(book)
        saveBooks()
    }
    
    func updateBook(_ book: Book) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index] = book
            saveBooks()
        }
    }
    
    func deleteBook(_ book: Book) {
        books.removeAll { $0.id == book.id }
        notes.removeAll { $0.bookId == book.id }
        saveBooks()
        saveNotes()
    }
    
    func updateReadingProgress(bookId: UUID, currentPage: Int) {
        if let index = books.firstIndex(where: { $0.id == bookId }) {
            books[index].currentPage = currentPage
            saveBooks()
        }
    }
    
    var trendingBooks: [Book] {
        books.filter { $0.isTrending }
    }
    
    var recommendedBooks: [Book] {
        let favoriteGenres = userPreferences.favoriteGenres
        if favoriteGenres.isEmpty {
            return books.sorted { $0.rating > $1.rating }.prefix(6).map { $0 }
        }
        return books.filter { favoriteGenres.contains($0.genre) }
            .sorted { $0.rating > $1.rating }
    }
    
    // MARK: - Notes Management
    
    func addNote(_ note: Note) {
        notes.append(note)
        saveNotes()
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            var updatedNote = note
            updatedNote.updatedAt = Date()
            notes[index] = updatedNote
            saveNotes()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    func getNotes(for bookId: UUID) -> [Note] {
        notes.filter { $0.bookId == bookId }.sorted { $0.createdAt > $1.createdAt }
    }
    
    // MARK: - Preferences Management
    
    func updatePreferences(_ preferences: UserPreferences) {
        userPreferences = preferences
        savePreferences()
    }
    
    func resetApp() {
        books.removeAll()
        notes.removeAll()
        userPreferences = UserPreferences()
        UserDefaults.standard.removeObject(forKey: booksKey)
        UserDefaults.standard.removeObject(forKey: notesKey)
        UserDefaults.standard.removeObject(forKey: preferencesKey)
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        loadSampleBooks()
    }
    
    // MARK: - Persistence
    
    private func saveBooks() {
        if let encoded = try? JSONEncoder().encode(books) {
            UserDefaults.standard.set(encoded, forKey: booksKey)
        }
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: notesKey)
        }
    }
    
    private func savePreferences() {
        if let encoded = try? JSONEncoder().encode(userPreferences) {
            UserDefaults.standard.set(encoded, forKey: preferencesKey)
        }
    }
    
    private func loadData() {
        if let booksData = UserDefaults.standard.data(forKey: booksKey),
           let decodedBooks = try? JSONDecoder().decode([Book].self, from: booksData) {
            books = decodedBooks
        }
        
        if let notesData = UserDefaults.standard.data(forKey: notesKey),
           let decodedNotes = try? JSONDecoder().decode([Note].self, from: notesData) {
            notes = decodedNotes
        }
        
        if let preferencesData = UserDefaults.standard.data(forKey: preferencesKey),
           let decodedPreferences = try? JSONDecoder().decode(UserPreferences.self, from: preferencesData) {
            userPreferences = decodedPreferences
        }
    }
    
    private func loadSampleBooks() {
        books = [
            Book(
                title: "The Great Gatsby",
                author: "F. Scott Fitzgerald",
                description: "A classic American novel set in the Jazz Age, exploring themes of decadence, idealism, resistance to change, and excess.",
                coverImage: "book.closed.fill",
                genre: "Classic",
                rating: 4.5,
                totalPages: 180,
                currentPage: 45,
                isTrending: true,
                publishedYear: 1925
            ),
            Book(
                title: "To Kill a Mockingbird",
                author: "Harper Lee",
                description: "A gripping tale of racial injustice and childhood innocence in the American South during the 1930s.",
                coverImage: "book.fill",
                genre: "Classic",
                rating: 4.8,
                totalPages: 324,
                currentPage: 120,
                isTrending: true,
                publishedYear: 1960
            ),
            Book(
                title: "1984",
                author: "George Orwell",
                description: "A dystopian social science fiction novel and cautionary tale about the dangers of totalitarianism.",
                coverImage: "book.closed.fill",
                genre: "Science Fiction",
                rating: 4.7,
                totalPages: 328,
                isTrending: true,
                publishedYear: 1949
            ),
            Book(
                title: "Pride and Prejudice",
                author: "Jane Austen",
                description: "A romantic novel of manners that follows the character development of Elizabeth Bennet.",
                coverImage: "book.fill",
                genre: "Romance",
                rating: 4.6,
                totalPages: 432,
                currentPage: 200,
                isTrending: false,
                publishedYear: 1813
            ),
            Book(
                title: "The Hobbit",
                author: "J.R.R. Tolkien",
                description: "A fantasy novel about the quest of home-loving Bilbo Baggins to win a share of treasure guarded by a dragon.",
                coverImage: "book.closed.fill",
                genre: "Fantasy",
                rating: 4.7,
                totalPages: 310,
                isTrending: true,
                publishedYear: 1937
            ),
            Book(
                title: "The Catcher in the Rye",
                author: "J.D. Salinger",
                description: "A story about teenage rebellion and alienation, narrated by the iconic character Holden Caulfield.",
                coverImage: "book.fill",
                genre: "Classic",
                rating: 4.0,
                totalPages: 277,
                currentPage: 89,
                isTrending: false,
                publishedYear: 1951
            ),
            Book(
                title: "Dune",
                author: "Frank Herbert",
                description: "A science fiction masterpiece set in the distant future amidst a huge interstellar empire.",
                coverImage: "book.closed.fill",
                genre: "Science Fiction",
                rating: 4.6,
                totalPages: 688,
                isTrending: true,
                publishedYear: 1965
            ),
            Book(
                title: "Harry Potter and the Sorcerer's Stone",
                author: "J.K. Rowling",
                description: "The magical journey of a young wizard attending Hogwarts School of Witchcraft and Wizardry.",
                coverImage: "book.fill",
                genre: "Fantasy",
                rating: 4.8,
                totalPages: 309,
                currentPage: 150,
                isTrending: true,
                publishedYear: 1997
            )
        ]
        saveBooks()
    }
}

