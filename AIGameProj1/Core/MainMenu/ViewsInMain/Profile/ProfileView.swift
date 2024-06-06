//
//  ProfileView.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 04.06.2024.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        VStack {
            HStack {
                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
            }

            if let user = viewModel.user, let photoUrl = user.photoUrl, let url = URL(string: photoUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding()
                } placeholder: {
                    ProgressView()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding()
                }
            } else {

                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()
            }

            List {

                Section {
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Text("Select a photo")
                    }
                    .onChange(of: selectedItem, perform: { newValue in
                        if let newValue {
                            viewModel.saveProfileImage(item: newValue)
                        }
                    })
                }

                Section {
                    if let user = viewModel.user {
                        Text("UserId: \(user.userId)")
                    }
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                viewModel.loadCurrentUser()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}
