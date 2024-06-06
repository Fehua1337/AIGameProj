//
//  SettingViewModel.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 23.05.2024.
//

import Foundation
import SwiftUI

class SettingViewModel: ObservableObject {
    
    func signOut(completion: @escaping (Bool, String?) -> Void) {
        AuthenticationManager.shared.signOut { result in
            switch result {
            case .success():
                completion(true, nil)
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    func resetPassword(completion: @escaping (Bool, String?) -> Void) {
        AuthenticationManager.shared.getAuthenticatedUser { result in
            switch result {
            case .success(let userData):
                if let email = userData.email {
                    AuthenticationManager.shared.resetPassword(email: email) { resetResult in
                        switch resetResult {
                        case .success():
                            print("Password reset email sent successfully.")
                            completion(true, "Password reset email sent successfully.")
                        case .failure(let error):
                            print("Failed to send password reset email: \(error.localizedDescription)")
                            completion(false, "Failed to send password reset email: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("No email associated with current user.")
                    completion(false, "No email associated with current user.")
                }
            case .failure(let error):
                print("Failed to get authenticated user: \(error.localizedDescription)")
                completion(false, "Failed to get authenticated user: \(error.localizedDescription)")
            }
        }
    }
    func updatePassword(password: String, completion: @escaping (Bool, String?) -> Void) {
            AuthenticationManager.shared.updatePassword(password: password) { result in
                switch result {
                case .success():
                    completion(true, nil)
                case .failure(let error):
                    completion(false, error.localizedDescription)
                }
            }
        }

        func updateEmail(email: String, completion: @escaping (Bool, String?) -> Void) {
            AuthenticationManager.shared.updateEmail(email: email) { result in
                switch result {
                case .success():
                    completion(true, nil)
                case .failure(let error):
                    completion(false, error.localizedDescription)
                }
            }
        }
}
