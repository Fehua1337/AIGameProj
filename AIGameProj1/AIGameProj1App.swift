//
//  AIGameProj1App.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 10.05.2024.
//

import SwiftUI
import Firebase

@main
struct AIGameProj1App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            RegistrationView()
        }
    }
}
