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
    
    let openAI = OpenAI(apiToken: "API key")
    var prompt = "Imagine that you are a game master, the game takes place in a fantasy world with magic and swords. You will guide the player by creating different events. The beginning of the player's journey will take place on a ship that was wrecked, after which the player character finds himself on an island next to which the walls of the kingdom are visible. Then come up with the plot yourself. The game should be interactive; after each event, wait for the player's response. You should only generate an event and not options for where the player will go. The player's answer can be anything."
    
    func sendNewMessage(content: String) {
        let userMessage = Message(content: content, isUser: true)
        self.messages.append(userMessage)
        getBotReply(text: prompt)
        
    }
    
    func getBotReply(text: String) {
        let query = ChatQuery(
            messages: [.init(role: .user, content: text)!] + self.messages.map({
                .init(role: .user, content: $0.content)!
            }),
            model: .gpt3_5Turbo_0125
        )
        
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else {
                    return
                }
                let message = choice.message.content?.string
                DispatchQueue.main.async {
                    self.messages.append(Message(content: message ?? "", isUser: false))
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
