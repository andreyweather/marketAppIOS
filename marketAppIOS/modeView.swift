//
//  modeView.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 13.11.2023.
//

import Foundation
import SwiftUI

struct modeView:  View {
    
    @State private var mode = 0
    
    var body: some View {
        VStack(spacing:0) {
            
            
            HStack(spacing: 50){
                VStack{
                    
                    Button(action: {
                        
                  
                        
                    }){
                        Image("cataloge")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25.0, height: 25.0, alignment: .bottom)
                    }
                    Text ("Каталог")
                        .font(Font.custom("MyFont", size: 10, relativeTo: .title))
                    
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
                    Button(action: {}){
                        Image("like")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25.0, height: 25.0, alignment: .bottom)
                    }
                    Text ("Избранное")
                        .font(Font.custom("MyFont", size: 10, relativeTo: .title))
                }
                VStack {
                    Button(action: {
                        mode = 3
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

