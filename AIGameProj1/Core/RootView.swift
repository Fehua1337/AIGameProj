//
//  RootView.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 23.05.2024.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                MainView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            AuthenticationManager.shared.getAuthenticatedUser { result in
                switch result {
                case .success(let userData):
                    self.showSignInView = false
                    print("User authenticated: \(userData.uid)")
                case .failure(let error):
                    self.showSignInView = true
                    print("No authenticated user or error: \(error)")
                }
            }
            applyTheme()
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        .onChange(of: isDarkMode) { _ in
            applyTheme()
        }
    }
    
    private func applyTheme() {
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }
}

#Preview {
    RootView()
}
