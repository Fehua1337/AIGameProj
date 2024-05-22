//
//  RegistrationView.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 20.05.2024.
//
import Foundation
import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()
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
            
            Button {
                viewModel.login()
            }label: {
                Text("Sign in")
            }
            .padding()
            .foregroundStyle(.white)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Spacer()
            
            HStack{
                Text("Dont have an account?")
                Button {
                    
                }label: {
                    Text("Register")
                }
            }
            .padding(.bottom, 50)
            
        }
        .padding()
    }
}
