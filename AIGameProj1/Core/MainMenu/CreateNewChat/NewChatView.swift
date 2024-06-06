//
//  NewChatView.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 05.06.2024.
//

import SwiftUI
import PhotosUI

struct NewChatView: View {
    @Binding var showingNewChatView: Bool
    @ObservedObject var viewModel: HomeViewModel
    @StateObject private var newChatViewModel = NewChatViewModel()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    var currentUserId: String
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Chat Details")) {
                    TextField("Chat Name", text: $newChatViewModel.chatName)
                    TextField("Chat Description", text: $newChatViewModel.chatDescription)
                    TextField("Chat Prompt", text: $newChatViewModel.chatPrompt)
                }
                
                Section(header: Text("Chat Image")) {
                                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                                        Text("Select an image")
                                    }
                                    .onChange(of: selectedItem, perform: { newValue in
                                        if let newValue {
                                            newChatViewModel.saveChatImage(item: newValue, userId: currentUserId)
                                        }
                                    })
                                
                    
                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                    }
                }
                
                Button(action: {
                    newChatViewModel.createChat(for: currentUserId) { success, error in
                        if success {
                            viewModel.fetchChats(for: currentUserId) 
                            showingNewChatView = false
                        } else {
                            newChatViewModel.errorMessage = error
                        }
                    }
                }) {
                    Text("Create Chat")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if let errorMessage = newChatViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("New Chat")
            .navigationBarItems(trailing: Button("Cancel") {
                showingNewChatView = false
            })
        }
    }
}
