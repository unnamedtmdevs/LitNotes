//
//  BooksViewModel.swift
//  KanLit Notes
//

import Foundation
import Combine

class BooksViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var trendingBooks: [Book] = []
    @Published var recommendedBooks: [Book] = []
    @Published var searchText: String = ""
    @Published var selectedGenre: String = "All"
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    let genres = ["All", "Classic", "Science Fiction", "Fantasy", "Romance", "Mystery", "Thriller"]
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        dataManager.$books
            .assign(to: &$books)
        
        dataManager.$books
            .map { books in
                books.filter { $0.isTrending }
            }
            .assign(to: &$trendingBooks)
        
        Publishers.CombineLatest(dataManager.$books, dataManager.$userPreferences)
            .map { books, preferences in
                let favoriteGenres = preferences.favoriteGenres
                if favoriteGenres.isEmpty {
                    return Array(books.sorted { $0.rating > $1.rating }.prefix(6))
                }
                return books.filter { favoriteGenres.contains($0.genre) }
                    .sorted { $0.rating > $1.rating }
            }
            .assign(to: &$recommendedBooks)
    }
    
    var filteredBooks: [Book] {
        var result = books
        
        if selectedGenre != "All" {
            result = result.filter { $0.genre == selectedGenre }
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.author.localizedCaseInsensitiveContains(searchText) ||
                $0.genre.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    func updateReadingProgress(for book: Book, currentPage: Int) {
        dataManager.updateReadingProgress(bookId: book.id, currentPage: currentPage)
    }
}

