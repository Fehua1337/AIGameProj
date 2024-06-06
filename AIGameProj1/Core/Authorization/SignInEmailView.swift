//
//  EmailView.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 23.05.2024.
//

import Foundation
import SwiftUI


struct SignInEmailView: View {
    
    @StateObject var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    Text("Sign in with email")
                        .font(.system(size: 35))
                        .bold()
                    Spacer()
                }
                Spacer()
                HStack {
                    TextField("Email...", text: $viewModel.email)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                }
                HStack {
                    SecureField("Password...", text: $viewModel.password)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                }
                HStack {
                    
                    Button("Sign in") {
                        viewModel.signIn { success, errorMessage in
                            if success {
                                showSignInView = false
                            } else {
                                print("Sign in failed: \(errorMessage ?? "Unknown error")")
                            
                                viewModel.signUp { signUpSuccess, signUpMessage in
                                    if signUpSuccess {
                                        showSignInView = false 
                                    } else {
                                        print("Sign up failed: \(signUpMessage ?? "Unknown error")")
                                    }
                                }
                            }
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                        
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct SignInEmailView_Preview: PreviewProvider {
    static var previews: some View {
        AuthenticationView(showSignInView: .constant(false))
    }
}
