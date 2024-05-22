//
//  LoginViewModel.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 22.05.2024.
//

import Foundation
import SwiftUI
import Firebase

class LoginViewModel: ObservableObject {

    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var reTypePassword: String = ""
    
    func login() {
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
        }
    }
}
