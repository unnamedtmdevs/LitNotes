//
//  BookDetailView.swift
//  LitNotes
//
//  Created by Simon Bakhanets on 09.12.2025.
//

import SwiftUI

struct BookDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var notesViewModel = NotesViewModel()
    @StateObject private var booksViewModel = BooksViewModel()
    
    let book: Book
    @State private var noteToEdit: Note?
    @State private var showingNoteSheet = false
    @State private var currentPage: String = ""
    
    var bookNotes: [Note] {
        notesViewModel.getNotes(for: book.id)
    }
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header with Close Button
                    HStack {
                        Spacer()
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.appWhite.opacity(0.7))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Book Cover and Info
                    VStack(spacing: 20) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.appYellow.opacity(0.2))
                            .frame(width: 200, height: 280)
                            .overlay(
                                Image(systemName: book.coverImage)
                                    .font(.system(size: 80))
                                    .foregroundColor(.appYellow)
                            )
                        
                        VStack(spacing: 8) {
                            Text(book.title)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.appWhite)
                                .multilineTextAlignment(.center)
                            
                            Text(book.author)
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(.appWhite.opacity(0.7))
                            
                            HStack(spacing: 16) {
                                Label(String(format: "%.1f", book.rating), systemImage: "star.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.appYellow)
                                
                                Text("•")
                                    .foregroundColor(.appWhite.opacity(0.5))
                                
                                Text(book.genre)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.appWhite.opacity(0.8))
                                
                                Text("•")
                                    .foregroundColor(.appWhite.opacity(0.5))
                                
                                Text("\(book.publishedYear)")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.appWhite.opacity(0.8))
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Reading Progress
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Reading Progress")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.appWhite)
                            
                            Spacer()
                            
                            Text("\(Int(book.progress * 100))%")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.appYellow)
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.1))
                                    .frame(height: 10)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.appYellow)
                                    .frame(width: geometry.size.width * book.progress, height: 10)
                            }
                        }
                        .frame(height: 10)
                        
                        HStack(spacing: 12) {
                            TextField("Current page", text: $currentPage)
                                .keyboardType(.numberPad)
                                .foregroundColor(.appWhite)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                            
                            Button(action: {
                                if let page = Int(currentPage), page > 0, page <= book.totalPages {
                                    booksViewModel.updateReadingProgress(for: book, currentPage: page)
                                    currentPage = ""
                                }
                            }) {
                                Text("Update")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.appBackground)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 14)
                                    .background(Color.appYellow)
                                    .cornerRadius(12)
                            }
                        }
                        
                        Text("Page \(book.currentPage) of \(book.totalPages)")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.appWhite.opacity(0.6))
                    }
                    .padding(.horizontal)
                    
                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About this book")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.appWhite)
                        
                        Text(book.description)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.appWhite.opacity(0.8))
                            .lineSpacing(6)
                    }
                    .padding(.horizontal)
                    
                    // Notes Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("My Notes")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.appWhite)
                            
                            Spacer()
                            
                            Button(action: {
                                noteToEdit = nil
                                showingNoteSheet = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.appYellow)
                            }
                        }
                        
                        if bookNotes.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "note.text")
                                    .font(.system(size: 50))
                                    .foregroundColor(.appWhite.opacity(0.3))
                                
                                Text("No notes yet")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.appWhite.opacity(0.6))
                                
                                Text("Tap + to add your first note")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.appWhite.opacity(0.5))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(bookNotes) { note in
                                    NoteCardView(note: note) {
                                        noteToEdit = note
                                        showingNoteSheet = true
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .onAppear {
            currentPage = String(book.currentPage)
        }
        .sheet(isPresented: $showingNoteSheet) {
            NoteEditorView(
                book: book,
                note: noteToEdit,
                onSave: { note in
                    if noteToEdit != nil {
                        notesViewModel.updateNote(note)
                    } else {
                        notesViewModel.addNote(note)
                    }
                    showingNoteSheet = false
                }
            )
        }
    }
}

struct NoteCardView: View {
    let note: Note
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                if let pageNumber = note.pageNumber {
                    Text("Page \(pageNumber)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.appYellow)
                }
                
                Text(note.content)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.appWhite)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                Text(note.createdAt, style: .date)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.appWhite.opacity(0.5))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
        }
    }
}

#Preview {
    BookDetailView(book: Book(
        title: "The Great Gatsby",
        author: "F. Scott Fitzgerald",
        description: "A classic American novel",
        coverImage: "book.closed.fill",
        genre: "Classic",
        rating: 4.5,
        totalPages: 180,
        currentPage: 45,
        publishedYear: 1925
    ))
}

