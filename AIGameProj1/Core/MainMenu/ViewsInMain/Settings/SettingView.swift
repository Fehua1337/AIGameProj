//
//  SwiftUIView.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 23.05.2024.
//

import SwiftUI

struct SettingView: View {
    @StateObject var viewModel = SettingViewModel()
    @Binding var showSignInView: Bool
    @State private var showMessageView: Bool = false
    @State private var resultMessage: String = ""
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        NavigationStack {
            List {
                Button("Log out") {
                    viewModel.signOut { success, errorMessage in
                        if success {
                            showSignInView = true
                        } else {
                            print("Logout failed: \(errorMessage ?? "Unknown error")")
                        }
                    }
                }
                Section(header: Text("Settings")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .onChange(of: isDarkMode) { value in
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = value ? .dark : .light
                        }
                    Button("Reset password") {
                        viewModel.resetPassword() { success, errorMessage in
                            if success {
                                resultMessage = errorMessage ?? "Success"
                                showMessageView = true
                            } else {
                                resultMessage = errorMessage ?? "Unknown error"
                                showMessageView = true
                            }
                        }
                    }
                    Button("Update password") {
                        let newPassword = "newPassword123"
                        viewModel.updatePassword(password: newPassword) { success, errorMessage in
                            if success {
                                resultMessage = "Password updated successfully."
                                showMessageView = true
                                resultMessage = "Failed to update password: \(errorMessage ?? "Unknown error")"
                                showMessageView = true
                            }
                        }
                    }
                    Button("Update email") {
                        let newEmail = "newemail@example.com"
                        viewModel.updateEmail(email: newEmail) { success, errorMessage in
                            if success {
                                resultMessage = "Email updated successfully."
                                showMessageView = true
                            } else {
                                resultMessage = "Failed to update email: \(errorMessage ?? "Unknown error")"
                                showMessageView = true  
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Settings")
            .background(
                NavigationLink(destination: ResultView(message: resultMessage), isActive: $showMessageView) {
                    EmptyView()
                }
            )
        }
    }
}




struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(showSignInView: .constant(false))
    }
}
