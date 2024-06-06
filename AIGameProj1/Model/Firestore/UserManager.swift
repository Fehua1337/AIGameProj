//
//  UserManager.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 04.06.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser {
    let userId: String
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
}

struct ChatListData: Identifiable {
    var id: String
    var name: String
    var description: String
    var prompt: String
    var imageUrl: String?
}

struct MessageData: Identifiable {
    let id: String
    let content: String
    let isUser: Bool
    let timestamp: Date
}

final class UserManager {
    static let shared = UserManager()
    private init() {}
    
    func createNewUser(auth: AuthDataResultModel, completion: @escaping (Result<Void, Error>) -> Void) {
            let userData: [String: Any] = [
                "user_id": auth.uid,
                "date_created": Date(),
                "email": auth.email ?? "",
                "photo_url": auth.photoUrl ?? ""
            ]
            
            Firestore.firestore().collection("users").document(auth.uid).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    
    func createChat(name: String, description: String, prompt: String, userId: String, imageUrl: String?, completion: @escaping (Result<Void, Error>) -> Void) {
            var chatData: [String: Any] = [
                "name": name,
                "description": description,
                "prompt": prompt,
                "user_id": userId,
                "date_created": Date()
            ]
            if let imageUrl = imageUrl {
                chatData["image_url"] = imageUrl
            }
            
            Firestore.firestore().collection("users").document(userId).collection("chats").addDocument(data: chatData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    
    func fetchChats(for userId: String, completion: @escaping (Result<[ChatListData], Error>) -> Void) {
          Firestore.firestore().collection("users").document(userId).collection("chats").order(by: "date_created", descending: true).getDocuments { snapshot, error in
              if let error = error {
                  completion(.failure(error))
              } else {
                  let chats = snapshot?.documents.compactMap { doc -> ChatListData? in
                      let data = doc.data()
                      let id = doc.documentID
                      let name = data["name"] as? String ?? "Unnamed Chat"
                      let description = data["description"] as? String ?? ""
                      let prompt = data["prompt"] as? String ?? ""
                      let imageUrl = data["image_url"] as? String
                      return ChatListData(id: id, name: name, description: description, prompt: prompt, imageUrl: imageUrl)
                  } ?? []
                  completion(.success(chats))
              }
          }
      }
    
    func fetchMessages(for chatId: String, userId: String, completion: @escaping (Result<[MessageData], Error>) -> Void) {
        Firestore.firestore().collection("users").document(userId).collection("chats").document(chatId).collection("messages").order(by: "timestamp").addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let messages = snapshot?.documents.compactMap { doc -> MessageData? in
                    let data = doc.data()
                    let id = doc.documentID
                    let content = data["content"] as? String ?? ""
                    let isUser = data["is_user"] as? Bool ?? false
                    let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    return MessageData(id: id, content: content, isUser: isUser, timestamp: timestamp)
                } ?? []
                completion(.success(messages))
            }
        }
    }
    
    func sendMessage(chatId: String, userId: String, content: String, isUser: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let messageData: [String: Any] = [
            "content": content,
            "is_user": isUser,
            "timestamp": Date()
        ]
        
        Firestore.firestore().collection("users").document(userId).collection("chats").document(chatId).collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        let email = data["email"] as? String
        let photoUrl = data["photo_url"] as? String
        let timestamp = data["date_created"] as? Timestamp
        let dateCreated = timestamp?.dateValue()
        
        return DBUser(userId: userId, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
    }
    
    func deleteChat(chatId: String, userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Firestore.firestore().collection("users").document(userId).collection("chats").document(chatId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateUserProfileImage(userId: String, imageUrl: String) async throws {
        try await Firestore.firestore().collection("users").document(userId).updateData(["photo_url": imageUrl])
    }
}
