//
//  Chat controller.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 18.05.2024.
//

import Foundation
import OpenAI

class ChatController: ObservableObject {
    @Published var messages: [Message] = []
    var chatId: String
    var userId: String
    var initialPrompt: String
    let openAI = OpenAI(apiToken: "Insert your OpenAI API here") //######################//

    init(chatId: String, userId: String, initialPrompt: String) {
        self.chatId = chatId
        self.userId = userId
        self.initialPrompt = initialPrompt
        fetchMessages()
    }
    
    func fetchMessages() {
        UserManager.shared.fetchMessages(for: chatId, userId: userId) { result in
            switch result {
            case .success(let messagesData):
                self.messages = messagesData.map { messageData in
                    Message(
                        id: messageData.id,
                        content: messageData.content,
                        isUser: messageData.isUser,
                        timestamp: messageData.timestamp
                    )
                }
            case .failure(let error):
                print("Error fetching messages: \(error.localizedDescription)")
            }
        }
    }
    
    func sendNewMessage(content: String) {
        let messageId = UUID().uuidString
        let timestamp = Date()
        let userMessage = Message(id: messageId, content: content, isUser: true, timestamp: timestamp)
        self.messages.append(userMessage)
        UserManager.shared.sendMessage(chatId: chatId, userId: userId, content: content, isUser: true) { result in
            switch result {
            case .success():
                self.getBotReply(text: content)
            case .failure(let error):
                print("Error sending message: \(error.localizedDescription)")
            }
        }
    }
    
    func getBotReply(text: String) {
        let query = ChatQuery(
            messages: [.init(role: .user, content: text)!] + self.messages.map {
                .init(role: .user, content: $0.content)!
            },
            model: .gpt3_5Turbo_0125
        )
        
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else {
                    return
                }
                let messageContent = choice.message.content?.string ?? ""
                DispatchQueue.main.async {
                    let messageId = UUID().uuidString
                    let timestamp = Date()
                    let botMessage = Message(id: messageId, content: messageContent, isUser: false, timestamp: timestamp)
                    self.messages.append(botMessage)
                    UserManager.shared.sendMessage(chatId: self.chatId, userId: self.userId, content: messageContent, isUser: false) { result in
                        if case let .failure(error) = result {
                            print("Error sending bot reply: \(error.localizedDescription)")
                        }
                    }
                }
            case .failure(let failure):
                print("Error getting bot reply: \(failure)")
            }
        }
    }
    
    func sendInitialAIReplyIfNeeded(prompt: String) {
        if messages.isEmpty {
            getBotReply(text: prompt)
        }
    }
}
