//
//  UserPreferences.swift
//  KanLit Notes
//

import Foundation

struct UserPreferences: Codable {
    var favoriteGenres: [String]
    var readingGoal: Int
    var isDarkMode: Bool
    var notificationsEnabled: Bool
    
    init(
        favoriteGenres: [String] = [],
        readingGoal: Int = 12,
        isDarkMode: Bool = true,
        notificationsEnabled: Bool = false
    ) {
        self.favoriteGenres = favoriteGenres
        self.readingGoal = readingGoal
        self.isDarkMode = isDarkMode
        self.notificationsEnabled = notificationsEnabled
    }
}

