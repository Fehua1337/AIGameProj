import SwiftUI

struct ChatView: View {
    @StateObject var chatController: ChatController
    @State var string: String = ""
    
    var chatData: ChatListData
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(chatController.messages) { message in
                    MessageView(message: message)
                        .padding(5)
                }
            }
            Divider()
            HStack {
                TextField("Message...", text: $string, axis: .vertical)
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
        .onAppear {
            chatController.sendInitialAIReplyIfNeeded(prompt: chatData.prompt)
        }
    }
}


