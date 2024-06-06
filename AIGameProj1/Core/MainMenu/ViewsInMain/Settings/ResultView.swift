//
//  ResultView.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 04.06.2024.
//

import SwiftUI

struct ResultView: View {
    var message: String
    
    var body: some View {
        Text(message)
            .padding()
            .navigationBarTitle("Result", displayMode: .inline)
    }
}
