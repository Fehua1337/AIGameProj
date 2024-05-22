//
//  AuthViewModel.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 20.05.2024.
//
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import SwiftUI

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var reTypePassword: String = ""
    
    func register() {
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
//    func onAppe
}
