//
//  MainView.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 18.05.2024.
//

import Foundation
import SwiftUI

struct MainView: View {
    @Binding var showSignInView: Bool
    
    @State private var tabSelection = 1
    
    
    
    var body: some View {
        NavigationStack {
            
                TabView(selection: $tabSelection) {
                    HomeView()
                        .tag(1)
                    BrowseView()
                        .tag(2)
                    SettingView(showSignInView: $showSignInView)
                        .tag(3)
                    ProfileView(showSignInView: $showSignInView)
                        .tag(4)
                }
                .overlay(alignment: .bottom) {
                    CustomTabView(tabSelection: $tabSelection)
                }
            }
        }
    }

#Preview {
    MainView(showSignInView: .constant(false))
}
