//
//  AuthView.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 20.05.2024.
//
import Foundation
import SwiftUI

struct RegistrationView: View {
    @ObservedObject var viewModel = RegistrationViewModel()
    var body: some View {
        VStack {
            Text("AI games")
                .font(.title)
                .bold()
                .padding(.top, 100)
            
            TextField("Email", text: $viewModel.emailText)
                .padding()
                .background(Color.gray.opacity(0.1))
                .textInputAutocapitalization(.never)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            SecureField("Password", text: $viewModel.passwordText)
                .padding()
                .background(Color.gray.opacity(0.1))
                .textInputAutocapitalization(.never)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            SecureField("Re-type password", text: $viewModel.reTypePassword)
                .padding()
                .background(Color.gray.opacity(0.1))
                .textInputAutocapitalization(.never)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            Button {
                viewModel.register()
            }label: {
                Text("Sign in")
            }
            .padding()
            .foregroundStyle(.white)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Spacer()
            HStack{
                Text("Already has an account?")
                Button {
                    
                } label: {
                    Text("Login")
                }
            }
            .padding(.bottom, 50)
            .onAppear() {
                
            }
            
        }
        .padding()
    }
}
struct AuthViewPreviews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
