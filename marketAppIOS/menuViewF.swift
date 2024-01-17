//
//  menuViewF.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 22.11.2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore

struct menuViewF: View {
    
    
    @State private var mode = 1
    @State private var basketQuantity = 0
    @StateObject var viewModel: SubviewModel = .init()
    @Binding var test: String?
    
    
    init(text: Binding<String?>) {
        self._test = text
    }
    
    var body: some View {
        menuView
    }
        
        var menuView: some View {
            
            
            VStack(spacing:0) {
                
                
                HStack(spacing: 50){
                    VStack{
                        
                        Button(action: {
                            mode = 4
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
                            
                            {
                                mode = 1
                            }
                            
                            
                        }){
                            
                            Image("cataloge")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25.0, height: 25.0, alignment: .bottom)
                        }
                        
                        Text ("Каталог")
                            .font(Font.custom("MyFont", size: 10, relativeTo: .title))
                        
                    }.padding(.leading, 5)
                    
                    VStack {
                        Button(action: {
                            
                            mode = 2
                        }){
                            
                            ZStack{
                                Image("basket")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25.0, height: 25.0, alignment: .bottom)
                                
                                if basketQuantity != 0 {
                                    ZStack {
                                        Image("blackcircle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 18.0, height: 18.0, alignment: .bottom)
                                        
                                        let bq = String(basketQuantity)
                                        Text (self.viewModel.subViewText ?? bq)
                                            .onChange(of: self.test) { (text) in
                                                let one = Int(text!)
                                                let sumQuantity = basketQuantity + one!
                                                var sumQuantityString = String(sumQuantity)
                                                self.viewModel.updateText(text: sumQuantityString)
                                            }
                                            .onAppear(perform: { self.viewModel.updateText(text: test) }).font(Font.custom("MyFont", size: 12, relativeTo: .title)).foregroundColor(.black)
                                        
                                    }.padding(.bottom, 15)
                                        .padding(.leading, 45)
                                }
                            }
                        }
                        
                        Text ("Корзина")
                            .font(Font.custom("MyFont", size: 10, relativeTo: .title))
                        
                    }.padding(.leading, 0)
                    
                    VStack {
                        Button(action: {
                            mode = 3
                        }){
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
                            mode = 4
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
                
            }.onAppear{
                
                loadBasketData()
            }
        }
        

        
        func loadBasketData () {
            
            
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let userUID = Auth.auth().currentUser?.uid
            
            var basketArray = [[String: String]]()
            
            
            ref.child("\(String(describing: userUID!)) BasketID").observeSingleEvent(of: .value, with: {  snapshot in
                
                var basketCount = snapshot.childrenCount
                
                let children = snapshot.children
                
                
                
                while let rest = children.nextObject() as? DataSnapshot, let value = rest.value {
                    basketArray.append(value as! [String: String])
                }
                
                if basketArray.count != 0 {
                    
                    basketQuantity = basketArray.count
                }
                
            })
            // ...
            { error in
                print(error.localizedDescription)
            }
        }
    }

