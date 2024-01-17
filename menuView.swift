//
//  menuView.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 15.11.2023.
//

import Foundation
import SwiftUI

class menuMode: ObservableObject {
    @Published var mode = 1
    
}

struct menuView: View {
    

    @ObservedObject var Mode = menuMode()
    
    var body: some View {
            
        
            VStack(spacing:0) {

                
                HStack(spacing: 50){
                    VStack{
                        
                        Image("cataloge")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25.0, height: 25.0, alignment: .bottom)
                           
                        Text ("Каталог")
                            .font(Font.custom("MyFont", size: 10, relativeTo: .title))
                        
                    } .onTapGesture {
                        catalogList()
                        menuView.self
                    }
                
                    VStack {
                        Button(action: {}){
                        Image("basket")
                                .resizable()
                                    .scaledToFit()
                                    .frame(width: 25.0, height: 25.0, alignment: .bottom)
                        }
                        Text ("Корзина")
                            .font(Font.custom("MyFont", size: 10, relativeTo: .title))
                        
                    }
                
                    VStack {
                        Button(action: {
                            Mode.mode = 2
                            print (Mode.mode)
                        }){
                        Image("like")
                                .resizable()
                                    .scaledToFit()
                                    .frame(width: 25.0, height: 25.0, alignment: .bottom)
                        }
                        Text ("Избранное")
                            .font(Font.custom("MyFont", size: 10, relativeTo: .title))
                    }.onTapGesture {
                        likeView()
                        menuView.self
                    }
                    VStack {
                        Button(action: {
                            Mode.mode = 3
                            print (Mode.mode)
                            
                        }){
                        Image("user")
                                .resizable()
                                    .scaledToFit()
                                    .frame(width: 25.0, height: 25.0, alignment: .bottom)
                        }
                        Text ("Профиль")
                            .font(Font.custom("MyFont", size: 10, relativeTo: .title))
                    }
                }.frame(width:400.0, height: 60.0, alignment: .center)
              }
           }
        }
    
    

