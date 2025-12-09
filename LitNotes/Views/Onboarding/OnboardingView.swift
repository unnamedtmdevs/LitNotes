//
//  OnboardingView.swift
//  LitNotes
//
//  Created by Simon Bakhanets on 09.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "book.fill",
            title: "Welcome to LitNotes",
            description: "Your personal literary companion for discovering, reading, and noting your favorite books",
            color: .appYellow
        ),
        OnboardingPage(
            icon: "sparkles",
            title: "Personalized Recommendations",
            description: "Get book suggestions tailored to your reading preferences and habits",
            color: .appYellow
        ),
        OnboardingPage(
            icon: "note.text",
            title: "Capture Your Thoughts",
            description: "Take notes while reading to remember key insights and favorite passages",
            color: .appYellow
        ),
        OnboardingPage(
            icon: "chart.line.uptrend.xyaxis",
            title: "Track Your Progress",
            description: "Monitor your reading journey and achieve your literary goals",
            color: .appYellow
        )
    ]
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Custom Page Indicator
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.appYellow : Color.appYellow.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.bottom, 30)
                
                // Navigation Buttons
                HStack(spacing: 20) {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            Text("Back")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.appWhite)
                                .frame(width: 100, height: 50)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(25)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            withAnimation {
                                hasCompletedOnboarding = true
                            }
                        }
                    }) {
                        Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.appBackground)
                            .frame(width: currentPage < pages.count - 1 ? 100 : 150, height: 50)
                            .background(Color.appYellow)
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 && currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else if value.translation.width > 50 && currentPage > 0 {
                        withAnimation {
                            currentPage -= 1
                        }
                    }
                }
        )
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: page.icon)
                .font(.system(size: 100))
                .foregroundColor(page.color)
                .padding(.bottom, 20)
            
            Text(page.title)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.appWhite)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Text(page.description)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.appWhite.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .lineSpacing(8)
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}

