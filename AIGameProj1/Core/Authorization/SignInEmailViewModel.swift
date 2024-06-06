//
//  SignInEmailViewModel.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 23.05.2024.
//

import Foundation

class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    
    
    func signIn(completion: @escaping (Bool, String?) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            completion(false, "No email or password found.")
            return
        }
        
        AuthenticationManager.shared.signInUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.isAuthenticated = true
                    self?.errorMessage = nil
                    completion(true, nil)
                case .failure(let error):
                    self?.isAuthenticated = false
                    self?.errorMessage = error.localizedDescription
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
    
    func signUp(completion: @escaping (Bool, String?) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            completion(false, "No email or password found.")
            return
        }
        
        AuthenticationManager.shared.createUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userData):
                    UserManager.shared.createNewUser(auth: userData) { result in
                        switch result {
                        case .success():
                            self?.isAuthenticated = true
                            self?.errorMessage = nil
                            completion(true, nil)
                        case .failure(let error):
                            self?.isAuthenticated = false
                            self?.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                            completion(false, "Failed to save user data: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    self?.isAuthenticated = false
                    self?.errorMessage = error.localizedDescription
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
}
