//
//  NotesViewModel.swift
//  LitNotes
//
//  Created by Simon Bakhanets on 09.12.2025.
//

import Foundation
import Combine

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var searchText: String = ""
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        dataManager.$notes
            .assign(to: &$notes)
    }
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notes.sorted { $0.createdAt > $1.createdAt }
        }
        return notes.filter {
            $0.content.localizedCaseInsensitiveContains(searchText) ||
            $0.bookTitle.localizedCaseInsensitiveContains(searchText)
        }.sorted { $0.createdAt > $1.createdAt }
    }
    
    func addNote(_ note: Note) {
        dataManager.addNote(note)
    }
    
    func updateNote(_ note: Note) {
        dataManager.updateNote(note)
    }
    
    func deleteNote(_ note: Note) {
        dataManager.deleteNote(note)
    }
    
    func getNotes(for bookId: UUID) -> [Note] {
        dataManager.getNotes(for: bookId)
    }
}

