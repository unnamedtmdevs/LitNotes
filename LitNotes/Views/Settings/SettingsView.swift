//
//  SettingsView.swift
//  LitNotes
//
//  Created by Simon Bakhanets on 09.12.2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var dataManager = DataManager.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @State private var showingDeleteAlert = false
    @State private var showingGenreSelection = false
    @State private var selectedGenres: Set<String> = []
    @State private var readingGoal: Double = 12
    
    let availableGenres = ["Classic", "Science Fiction", "Fantasy", "Romance", "Mystery", "Thriller", "Horror", "Biography", "History", "Self-Help"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Settings")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.appWhite)
                            
                            Text("Customize your experience")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(.appWhite.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        // Reading Preferences
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Reading Preferences")
                            
                            VStack(spacing: 0) {
                                Button(action: {
                                    selectedGenres = Set(dataManager.userPreferences.favoriteGenres)
                                    showingGenreSelection = true
                                }) {
                                    SettingsRow(
                                        icon: "bookmark.fill",
                                        title: "Favorite Genres",
                                        subtitle: dataManager.userPreferences.favoriteGenres.isEmpty ? "Not set" : dataManager.userPreferences.favoriteGenres.joined(separator: ", "),
                                        showChevron: true
                                    )
                                }
                                
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                    .padding(.leading, 60)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "target")
                                            .font(.system(size: 24))
                                            .foregroundColor(.appYellow)
                                            .frame(width: 44)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Annual Reading Goal")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.appWhite)
                                            
                                            Text("\(Int(readingGoal)) books per year")
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundColor(.appWhite.opacity(0.6))
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 16)
                                    
                                    Slider(value: $readingGoal, in: 1...100, step: 1)
                                        .accentColor(.appYellow)
                                        .padding(.horizontal)
                                        .padding(.bottom, 16)
                                        .onChange(of: readingGoal) { newValue in
                                            var prefs = dataManager.userPreferences
                                            prefs.readingGoal = Int(newValue)
                                            dataManager.updatePreferences(prefs)
                                        }
                                }
                            }
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(15)
                        }
                        .padding(.horizontal)
                        
                        // About
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "About")
                            
                            SettingsRow(
                                icon: "info.circle.fill",
                                title: "LitNotes",
                                subtitle: "Version 1.0.0",
                                showChevron: false
                            )
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(15)
                        }
                        .padding(.horizontal)
                        
                        // Danger Zone
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Danger Zone")
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.red)
                                        .frame(width: 44)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Reset App")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.red)
                                        
                                        Text("Delete all data and return to onboarding")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.red.opacity(0.7))
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .alert("Reset App", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    dataManager.resetApp()
                    hasCompletedOnboarding = false
                }
            } message: {
                Text("Are you sure you want to reset the app? This will delete all your books, notes, and preferences. This action cannot be undone.")
            }
            .sheet(isPresented: $showingGenreSelection) {
                GenreSelectionView(
                    selectedGenres: $selectedGenres,
                    onSave: {
                        var prefs = dataManager.userPreferences
                        prefs.favoriteGenres = Array(selectedGenres)
                        dataManager.updatePreferences(prefs)
                        showingGenreSelection = false
                    }
                )
            }
        }
        .onAppear {
            readingGoal = Double(dataManager.userPreferences.readingGoal)
        }
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.appWhite)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let showChevron: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.appYellow)
                .frame(width: 44)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.appWhite)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.appWhite.opacity(0.6))
            }
            
            Spacer()
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.appWhite.opacity(0.4))
            }
        }
        .padding()
    }
}

struct GenreSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedGenres: Set<String>
    let onSave: () -> Void
    
    let availableGenres = ["Classic", "Science Fiction", "Fantasy", "Romance", "Mystery", "Thriller", "Horror", "Biography", "History", "Self-Help"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(availableGenres, id: \.self) { genre in
                            Button(action: {
                                if selectedGenres.contains(genre) {
                                    selectedGenres.remove(genre)
                                } else {
                                    selectedGenres.insert(genre)
                                }
                            }) {
                                HStack {
                                    Text(genre)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.appWhite)
                                    
                                    Spacer()
                                    
                                    if selectedGenres.contains(genre) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(.appYellow)
                                    } else {
                                        Image(systemName: "circle")
                                            .font(.system(size: 24))
                                            .foregroundColor(.appWhite.opacity(0.3))
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Select Favorite Genres")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.appWhite)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        onSave()
                    }) {
                        Text("Save")
                            .fontWeight(.semibold)
                            .foregroundColor(.appYellow)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Select Favorite Genres")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.appWhite)
                }
            })
        }
    }
}

#Preview {
    SettingsView()
}

