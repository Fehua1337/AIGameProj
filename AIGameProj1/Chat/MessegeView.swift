//
//  MessegeView.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 18.05.2024.
//

import Foundation
import SwiftUI

struct MessageView: View {
    var message: Message
    var body: some View {
        Group {
            if message.isUser {
                HStack {
                    Spacer()
                    Text(message.content)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(Rectangle())
                }
            } else {
                HStack {
                    Text(message.content)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .clipShape(Rectangle())
                    Spacer()
                }
            }
        }
    }
}
