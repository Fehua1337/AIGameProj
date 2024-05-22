import SwiftUI
import OpenAI

struct ContentView: View {
    @StateObject var chatController: ChatController
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
        .onAppear{
            self.chatController.getBotReply(text: self.chatController.prompt)
        }
    }
}



//#Preview {
//    ContentView()
//}
