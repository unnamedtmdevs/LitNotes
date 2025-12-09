//
//  MainTabView.swift
//  KanLit Notes
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Content based on selected tab
            Group {
                if selectedTab == 0 {
                    HomeView()
                } else if selectedTab == 1 {
                    NotesView()
                } else {
                    SettingsView()
                }
            }
            
            // Custom Tab Bar
            HStack(spacing: 0) {
                TabBarButton(
                    icon: "house.fill",
                    title: "Home",
                    isSelected: selectedTab == 0
                ) {
                    withAnimation {
                        selectedTab = 0
                    }
                }
                
                TabBarButton(
                    icon: "note.text",
                    title: "Notes",
                    isSelected: selectedTab == 1
                ) {
                    withAnimation {
                        selectedTab = 1
                    }
                }
                
                TabBarButton(
                    icon: "gearshape.fill",
                    title: "Settings",
                    isSelected: selectedTab == 2
                ) {
                    withAnimation {
                        selectedTab = 2
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.appBackground.opacity(0.95))
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: -5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .appYellow : .appWhite.opacity(0.5))
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(title)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .appYellow : .appWhite.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    MainTabView()
}

