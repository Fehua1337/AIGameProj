//
//  AppDelegate.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 20.05.2024.
//
import UIKit
import Firebase
import Foundation

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
