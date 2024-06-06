//
//  HomeViewModel.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 04.06.2024.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    @Published var chats: [ChatListData] = []
    
    private var db = Firestore.firestore()
    func chatCellView(chatData: ChatListData) -> some View {
          HStack {
              if let imageUrl = chatData.imageUrl, let url = URL(string: imageUrl) {
                  AsyncImage(url: url) { image in
                      image.resizable()
                           .aspectRatio(contentMode: .fill)
                           .frame(width: 80, height: 80)
                           .clipped()
                  } placeholder: {
                      Image(systemName: "photo")
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .frame(width: 80, height: 80)
                          .clipped()
                          .background(Color.gray)
                  }
              } else {
                  Image(systemName: "photo")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 80, height: 80)
                      .clipped()
                      .background(Color.gray)
              }
              VStack(alignment: .leading) {
                  Text(chatData.name)
                      .foregroundStyle(.black)
                      .padding([.top, .leading, .trailing], 10)
                  
                  Spacer()
                  
                  Text(chatData.description)
                      .foregroundStyle(.black)
                      .padding([.bottom, .leading, .trailing], 10)
              }
          }
      }
    
    func fetchChats(for userId: String) {
        UserManager.shared.fetchChats(for: userId) { result in
            switch result {
            case .success(let chats):
                self.chats = chats
            case .failure(let error):
                print("Error fetching chats: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteChat(chatId: String, userId: String) {
        UserManager.shared.deleteChat(chatId: chatId, userId: userId) { result in
            switch result {
            case .success():
                print("Chat deleted successfully")
            case .failure(let error):
                print("Error deleting chat: \(error.localizedDescription)")
            }
        }
    }
    
}


