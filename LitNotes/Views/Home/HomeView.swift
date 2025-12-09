//
//  HomeView.swift
//  KanLit Notes
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = BooksViewModel()
    @State private var selectedBook: Book?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Discover")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.appWhite)
                            
                            Text("Your next great read")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(.appWhite.opacity(0.7))
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.appWhite.opacity(0.6))
                            
                            TextField("Search books, authors, genres...", text: $viewModel.searchText)
                                .foregroundColor(.appWhite)
                                .font(.system(size: 16))
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        // Genre Filter
                        if viewModel.searchText.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.genres, id: \.self) { genre in
                                        Button(action: {
                                            withAnimation {
                                                viewModel.selectedGenre = genre
                                            }
                                        }) {
                                            Text(genre)
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(viewModel.selectedGenre == genre ? .appBackground : .appWhite)
                                                .padding(.horizontal, 20)
                                                .padding(.vertical, 10)
                                                .background(viewModel.selectedGenre == genre ? Color.appYellow : Color.white.opacity(0.1))
                                                .cornerRadius(20)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Trending Books
                        if viewModel.searchText.isEmpty && viewModel.selectedGenre == "All" && !viewModel.trendingBooks.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Trending Now")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.appWhite)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(viewModel.trendingBooks) { book in
                                            TrendingBookCard(book: book)
                                                .onTapGesture {
                                                    selectedBook = book
                                                }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        // Recommended Books
                        if viewModel.searchText.isEmpty && viewModel.selectedGenre == "All" && !viewModel.recommendedBooks.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Recommended for You")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.appWhite)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(viewModel.recommendedBooks) { book in
                                            BookCard(book: book)
                                                .onTapGesture {
                                                    selectedBook = book
                                                }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        // All Books or Filtered Results
                        VStack(alignment: .leading, spacing: 16) {
                            Text(viewModel.searchText.isEmpty ? "All Books" : "Search Results")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.appWhite)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ForEach(viewModel.filteredBooks) { book in
                                    BookCard(book: book)
                                        .onTapGesture {
                                            selectedBook = book
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedBook) { book in
                BookDetailView(book: book)
            }
        }
    }
}

struct TrendingBookCard: View {
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.appYellow.opacity(0.2))
                    .frame(width: 280, height: 180)
                    .overlay(
                        Image(systemName: book.coverImage)
                            .font(.system(size: 60))
                            .foregroundColor(.appYellow)
                    )
                
                // Trending Badge
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 10))
                    Text("Trending")
                        .font(.system(size: 10, weight: .semibold))
                }
                .foregroundColor(.appBackground)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.appYellow)
                .cornerRadius(10)
                .padding(10)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(book.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.appWhite)
                    .lineLimit(1)
                
                Text(book.author)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.appWhite.opacity(0.7))
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.appYellow)
                    Text(String(format: "%.1f", book.rating))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.appWhite)
                }
            }
            .padding(.top, 12)
        }
        .frame(width: 280)
    }
}

struct BookCard: View {
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.appYellow.opacity(0.15))
                    .frame(height: 200)
                    .overlay(
                        Image(systemName: book.coverImage)
                            .font(.system(size: 50))
                            .foregroundColor(.appYellow)
                    )
                
                // Progress Bar
                if book.currentPage > 0 {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 4)
                            
                            Rectangle()
                                .fill(Color.appYellow)
                                .frame(width: geometry.size.width * book.progress, height: 4)
                        }
                    }
                    .frame(height: 4)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.appWhite)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(book.author)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.appWhite.opacity(0.7))
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.appYellow)
                    Text(String(format: "%.1f", book.rating))
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.appWhite)
                }
                .padding(.top, 2)
            }
        }
    }
}

#Preview {
    HomeView()
}

