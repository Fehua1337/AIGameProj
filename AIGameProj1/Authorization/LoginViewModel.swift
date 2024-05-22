//
//  LoginViewModel.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 22.05.2024.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {

    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var reTypePassword: String = ""
    
}
