//
//  ContentView.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 10.05.2024.
//

import SwiftUI
import OpenAI

class ChatController: ObservableObject {
    @Published var messages: [Message] = [.init(content: "Hello", isUser: true), .init(content: "Hello", isUser: false)]
    
    let openAI = OpenAI(apiToken: "sk-proj-vI71YEsAziAvS1EEtRPTT3BlbkFJvVp2eZvXdHYVrUzpdVjB")
    
    func sendNewMessage(content: String) {
        let userMessage = Message(content: content, isUser: true)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        let query = ChatQuery(
            messages: [.init(role: .user, content: "Imagine that you are a game master, the game takes place in a fantasy world with magic and swords. You will guide the player by creating different events. The beginning of the player's journey will take place on a ship that was wrecked, after which the player character finds himself on an island next to which the walls of the kingdom are visible. Then come up with the plot yourself. The game should be interactive; after each event, wait for the player's response. You should only generate an event and not options for where the player will go. The player's answer can be anything.")!] + self.messages.map({
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

struct Message: Identifiable {
    var id: UUID = .init()
    var content: String
    var isUser: Bool
}

struct ContentView: View {
    @StateObject var chatController: ChatController = .init()
    @State var string: String = ""
    var body: some View {
        VStack {
            ScrollView {
                ForEach(chatController.messages) {
                    message in
                    MessageView(message: message)
                        .padding(5)
                }
            }
            Divider()
            HStack {
                TextField("Message.....", text: self.$string, axis: .vertical)
                    .padding(5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                Button {
                    self.chatController.sendNewMessage(content: string)
                    string = ""
                } label: {
                    Image(systemName: "paperplane")
                }
            }
            .padding()
        }
    }
}

struct MessageView: View {
    var message: Message
    var body: some View {
        Group {
            if message.isUser {
                HStack {
                    Spacer()
                    Text(message.content)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(Rectangle())
                }
            } else {
                HStack {
                    Text(message.content)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .clipShape(Rectangle())
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
