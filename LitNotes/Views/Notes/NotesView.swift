//
//  NotesView.swift
//  KanLit Notes
//

import SwiftUI

struct NotesView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var selectedNote: Note?
    @State private var showingNoteEditor = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("My Notes")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.appWhite)
                        
                        Text("\(viewModel.notes.count) notes")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.appWhite.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.appWhite.opacity(0.6))
                        
                        TextField("Search notes...", text: $viewModel.searchText)
                            .foregroundColor(.appWhite)
                            .font(.system(size: 16))
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    // Notes List
                    if viewModel.filteredNotes.isEmpty {
                        Spacer()
                        
                        VStack(spacing: 16) {
                            Image(systemName: "note.text")
                                .font(.system(size: 60))
                                .foregroundColor(.appWhite.opacity(0.3))
                            
                            Text(viewModel.searchText.isEmpty ? "No notes yet" : "No matching notes")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.appWhite.opacity(0.7))
                            
                            if viewModel.searchText.isEmpty {
                                Text("Start taking notes from any book detail page")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.appWhite.opacity(0.5))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                        }
                        
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.filteredNotes) { note in
                                    NoteListCard(note: note)
                                        .onTapGesture {
                                            selectedNote = note
                                        }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedNote) { note in
                if let book = DataManager.shared.books.first(where: { $0.id == note.bookId }) {
                    NoteEditorView(
                        book: book,
                        note: note,
                        onSave: { updatedNote in
                            viewModel.updateNote(updatedNote)
                            selectedNote = nil
                        }
                    )
                }
            }
        }
    }
}

struct NoteListCard: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(note.bookTitle)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.appYellow)
                    
                    if let pageNumber = note.pageNumber {
                        Text("Page \(pageNumber)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.appWhite.opacity(0.6))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.appWhite.opacity(0.4))
            }
            
            Text(note.content)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.appWhite)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            HStack {
                Text(note.createdAt, style: .date)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.appWhite.opacity(0.5))
                
                if note.createdAt != note.updatedAt {
                    Text("•")
                        .foregroundColor(.appWhite.opacity(0.3))
                    
                    Text("Edited")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.appWhite.opacity(0.5))
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(15)
    }
}

#Preview {
    NotesView()
}

