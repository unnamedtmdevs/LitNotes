//
//  LitNotesApp.swift
//  LitNotes
//
//  Created by Simon Bakhanets on 09.12.2025.
//

import SwiftUI

@main
struct LitNotesApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
    }
}
