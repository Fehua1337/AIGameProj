//
//  MainView.swift
//  AIGameProj1
//
//  Created by Alisher Tulembekov on 18.05.2024.
//

import Foundation
import SwiftUI

struct MainView: View {
    
    let listData: [ChatListData] = [
        ChatListData(name: "Fantasy game", discription: "A fantasy game where you wake up on beach after ship wrecked")
    ]
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .frame(height: 55)
                    .foregroundColor(Color(red: 0.92, green: 0.92, blue: 0.92))//создать много маленьких ректангелов для красоты
                
                HStack{
                    Image(systemName: "line.3.horizontal")
                        .imageScale(.large)
                        .foregroundColor(.red)
                        .padding([.leading, .trailing])
                    Spacer()
                    Text("AI game")
                    //                    .font(.headline)
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "person.circle")
                            .font(.system(size: 35))
                            .padding([.leading, .trailing])
                    }
                }
            }
            ZStack{
                HStack{
                    Rectangle()
                        .frame(height: 27)
                        .foregroundColor(Color(red: 0.92, green: 0.92, blue: 0.92))
                }
                HStack {
                    Rectangle()
                        .frame(height: 1)
                    Spacer()
                    Text("Chats")
                    Spacer()
                    Rectangle()
                        .frame(height: 1)
                }
            }
            List(listData) {discrption in
                    Button(action: {
                        
                    }) {
                        HStack{
                            Image("ChatAvat")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80) // Увеличен размер для лучшей видимости
                                .clipped()
                            HStack {
                                VStack {
                                    Text(discrption.name)
                                        .foregroundStyle(.black)
                                        .padding([.top, .leading, .trailing], 10)
                                        
                                    Spacer()
                                    Text(discrption.discription)
                                        .foregroundStyle(.black)
                                        .padding([.bottom, .leading, .trailing], 10)
                                    Spacer()
                                    
                                }
                           
                            }
                        }
                    }
                }
                Spacer()
          
            }
        
    }
}

#Preview {
    MainView()
}
