//
//  NewChatViewModel.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 05.06.2024.
//

import Foundation
import SwiftUI
import PhotosUI

class NewChatViewModel: ObservableObject {
    @Published var chatName: String = ""
    @Published var chatDescription: String = ""
    @Published var chatPrompt: String = ""
    @Published var selectedImageData: Data? = nil
    @Published var errorMessage: String? = nil
    @Published var chatImageUrl: String? = nil
    
    func createChat(for userId: String, completion: @escaping (Bool, String?) -> Void) {
        guard !chatName.isEmpty, !chatDescription.isEmpty, !chatPrompt.isEmpty else {
            completion(false, "All fields are required.")
            return
        }
        
        UserManager.shared.createChat(name: chatName, description: chatDescription, prompt: chatPrompt, userId: userId, imageUrl: chatImageUrl) { result in
            switch result {
            case .success():
                completion(true, nil)
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    func saveChatImage(item: PhotosPickerItem, userId: String) {
            Task {
                guard let data = try await item.loadTransferable(type: Data.self) else { return }
                let (path, name) = try await StorageManager.shared.saveImage(data: data, userId: userId)
                let url = try await StorageManager.shared.getDownloadURL(path: path)
                DispatchQueue.main.async {
                    self.chatImageUrl = url.absoluteString
                }
            }
        }
}
