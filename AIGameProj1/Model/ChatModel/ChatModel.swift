//
//  chatView.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 15.05.2024.
//

import Foundation

struct Message: Identifiable {
    var id: String
    var content: String
    var isUser: Bool
    var timestamp: Date
}
 
