//
//  NoteEditorView.swift
//  LitNotes
//
//  Created by Simon Bakhanets on 09.12.2025.
//

import SwiftUI

struct NoteEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var notesViewModel = NotesViewModel()
    
    let book: Book
    let note: Note?
    let onSave: (Note) -> Void
    
    @State private var noteContent: String = ""
    @State private var pageNumber: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Page Number Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Page Number (Optional)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.appWhite.opacity(0.7))
                        
                        TextField("e.g., 42", text: $pageNumber)
                            .keyboardType(.numberPad)
                            .foregroundColor(.appWhite)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Note Content
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Note")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.appWhite.opacity(0.7))
                        
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                            
                            TextEditor(text: $noteContent)
                                .foregroundColor(.appWhite)
                                .background(Color.clear)
                                .cornerRadius(12)
                                .frame(minHeight: 200)
                                .focused($isFocused)
                        }
                        .frame(minHeight: 200)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Action Buttons
                    HStack(spacing: 16) {
                        if note != nil {
                            Button(action: {
                                if let noteToDelete = note {
                                    notesViewModel.deleteNote(noteToDelete)
                                    dismiss()
                                }
                            }) {
                                Image(systemName: "trash.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.red)
                                    .frame(width: 50, height: 50)
                                    .background(Color.red.opacity(0.2))
                                    .cornerRadius(25)
                            }
                        }
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.appWhite)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(25)
                        }
                        
                        Button(action: {
                            saveNote()
                        }) {
                            Text("Save")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.appBackground)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.appYellow)
                                .cornerRadius(25)
                        }
                        .disabled(noteContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .opacity(noteContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1.0)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding(.top, 20)
            }
            .navigationTitle(note == nil ? "New Note" : "Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text(note == nil ? "New Note" : "Edit Note")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.appWhite)
                }
            })
        }
        .onAppear {
            if let existingNote = note {
                noteContent = existingNote.content
                if let page = existingNote.pageNumber {
                    pageNumber = String(page)
                }
            }
            isFocused = true
        }
    }
    
    private func saveNote() {
        let trimmedContent = noteContent.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedContent.isEmpty else { return }
        
        let page = Int(pageNumber)
        
        if let existingNote = note {
            let updatedNote = Note(
                id: existingNote.id,
                bookId: book.id,
                bookTitle: book.title,
                content: trimmedContent,
                pageNumber: page,
                createdAt: existingNote.createdAt,
                updatedAt: Date()
            )
            onSave(updatedNote)
        } else {
            let newNote = Note(
                bookId: book.id,
                bookTitle: book.title,
                content: trimmedContent,
                pageNumber: page
            )
            onSave(newNote)
        }
    }
}

#Preview {
    NoteEditorView(
        book: Book(
            title: "The Great Gatsby",
            author: "F. Scott Fitzgerald",
            description: "A classic",
            coverImage: "book.closed.fill",
            genre: "Classic",
            rating: 4.5,
            totalPages: 180,
            publishedYear: 1925
        ),
        note: nil,
        onSave: { _ in }
    )
}

