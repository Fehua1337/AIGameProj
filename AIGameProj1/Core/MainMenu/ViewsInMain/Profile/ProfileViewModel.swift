//
//  ProfileViewModel.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 05.06.2024.
//

import Foundation
import PhotosUI
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published var errorMessage: String? = nil

    func loadCurrentUser() {
        AuthenticationManager.shared.getAuthenticatedUser { [weak self] result in
            switch result {
            case .success(let authDataResult):
                Task {
                    do {
                        let user = try await UserManager.shared.getUser(userId: authDataResult.uid)
                        DispatchQueue.main.async {
                            self?.user = user
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self?.errorMessage = error.localizedDescription
                        }
                        print("Error loading user: \(error)")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
                print("Error loading authenticated user: \(error)")
            }
        }
    }
    
    func saveProfileImage(item: PhotosPickerItem) {
        print("saveProfileImage called")
        Task {
            do {
                guard let data = try await item.loadTransferable(type: Data.self),
                      let userId = user?.userId else { return }
                let (path, _) = try await StorageManager.shared.saveImage(data: data, userId: userId)
                
                let downloadURL = try await StorageManager.shared.getDownloadURL(path: path)
                
                try await UserManager.shared.updateUserProfileImage(userId: userId, imageUrl: downloadURL.absoluteString)
                print("Profile image updated successfully.")
                loadCurrentUser()
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to update profile image: \(error.localizedDescription)"
                }
                print("Failed to update profile image: \(error)")
            }
        }
    }
}
