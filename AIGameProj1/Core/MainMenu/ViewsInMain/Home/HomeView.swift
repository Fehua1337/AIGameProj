//
//  HomeView.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 03.06.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State private var showingNewChatView = false
    @State private var currentUserId: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                headerView
                chatListView
                Spacer()
            }
            .navigationBarTitle("AI game")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(
                VStack {
                    Spacer()
                    Button(action: {
                        showingNewChatView = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 30))
                            .frame(width: 60, height: 60)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding(.bottom, 30)
                }
            )
            .onAppear {
                AuthenticationManager.shared.getAuthenticatedUser { result in
                    switch result {
                    case .success(let userData):
                        self.currentUserId = userData.uid
                        viewModel.fetchChats(for: userData.uid)
                    case .failure(let error):
                        print("Error fetching authenticated user: \(error)")
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewChatView) {
            NewChatView(showingNewChatView: $showingNewChatView, viewModel: viewModel, currentUserId: currentUserId)
        }
    }
    
    var headerView: some View {
        ZStack {
            Rectangle()
                .frame(height: 55)
                .foregroundColor(Color(red: 0.92, green: 0.92, blue: 0.92))
            
            HStack {
                Button(action: {}) {
                    Image(systemName: "line.horizontal.3")
                        .opacity(0)
                }
                Spacer()
                Text("AI game")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "line.horizontal.3")
                        .opacity(0)
                }
                .padding(.trailing, 15)
            }
        }
    }
    
    var chatListView: some View {
        List {
            ForEach(viewModel.chats) { chatData in
                NavigationLink(destination: ChatView(chatController: ChatController(chatId: chatData.id, userId: currentUserId, initialPrompt: chatData.prompt), chatData: chatData)) {
                    viewModel.chatCellView(chatData: chatData)
                }
            }
            .onDelete(perform: deleteChat)
        }
    }
    
    func deleteChat(at offsets: IndexSet) {
        offsets.forEach { index in
            let chat = viewModel.chats[index]
            viewModel.deleteChat(chatId: chat.id, userId: currentUserId)
        }
        viewModel.chats.remove(atOffsets: offsets)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

