//
//  positionFromMarket.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 16.11.2023.
//


import Foundation
import SwiftUI
import Firebase
import FirebaseCore


struct positionFromMarket: View {
    
    @EnvironmentObject var positionData: fireStoredataManager
    
    var positionID: String = ""
    
    init (poitionId: String) {
        
        positionID = poitionId
    }
    
    @State var buttonText = "ДОБАВИТЬ В КОРЗИНУ"
    @State var likeMode = false
    
    var userUID = Auth.auth().currentUser?.uid
    
    var body: some View {
        
        
        
        VStack {
            
            ForEach (positionData.positions, id: \.id) { pos  in
                
                if pos.id == positionID {
                    VStack{
                        ZStack {
                        
                            Rectangle()

                                .padding(1.0)
                                .frame(width: 385, height: 320).foregroundColor(.white)
                                .background(Color("CardBackground"))
                                .cornerRadius(5)
                                .shadow(color: Color.black.opacity(0.2), radius: 4)
                            
                            HStack{
                                remoteImage(url: pos.marketImg)
                            }.frame(width: 230, height: 260, alignment: .center)
                            
                            
                            HStack{
                                Image("inbasket")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32.0, height: 35.0, alignment: .top)
                                    .padding(.top, 20)
                                    .padding(.leading, 0)
                                    
                                Spacer()
                                Button(action: {
                                    
                                    likeMode = true
                                    
                                    var ref: DatabaseReference!
                                    ref = Database.database().reference()
                                    
                                    ref.child("\(String(describing: userUID!)) LikeID").child(pos.id).setValue(["id": pos.id])
                                    
                                    print (userUID!)
                                    
                                }){
                                    if (!likeMode) {
                                        
                                        Image("like")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 35.0, height: 35.0, alignment: .top)
                                            .padding(.top, 20)
                                            .padding(.trailing, 0)
                                    }
                                }
                                Button(action: {
                                    
                                    likeMode = false
                                    var ref: DatabaseReference!
                                    ref = Database.database().reference()
                                    
                                    ref.child("\(String(describing: userUID!)) LikeID").child(pos.id).removeValue()
                                
                                }){
                                    
                                    if (likeMode) {
                                        Image("afterlike")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 35.0, height: 35.0, alignment: .top)
                                            .padding(.top, 20)
                                            .padding(.trailing, 0)
                                    }
                                }
                            }.frame(width: 330, height: 300, alignment: .top)
                            
                        }
                    
                        ZStack {
                            Rectangle()

                                .padding(1.0)
                                .frame(width: 385, height: 35).foregroundColor(.white)
                                .background(Color("CardBackground"))
                                .cornerRadius(5)
                                .shadow(color: Color.black.opacity(0.2), radius: 4)
                            
                            Text (pos.brandPosition)
                                .frame(width: 250, height: 33, alignment: .leading)
                                .padding(.leading, -90)
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            
                        }
                        
                        ZStack {
                            Rectangle()

                                .padding(1.0)
                                .frame(width: 385, height: 35).foregroundColor(.white)
                                .background(Color("CardBackground"))
                                .cornerRadius(5)
                                .shadow(color: Color.black.opacity(0.2), radius: 4)
                            
                            Text (pos.namePosition)
                                .frame(width: 250, height: 33, alignment: .leading)
                                .padding(.leading, -90)
                                .font(.system(size: 12))
                                .fontWeight(.light)
                                .foregroundColor(.black)
                        }
                        
                        ZStack {
                            Rectangle()

                                .padding(1.0)
                                .frame(width: 385, height: 35).foregroundColor(.white)
                                .background(Color("CardBackground"))
                                .cornerRadius(5)
                                .shadow(color: Color.black.opacity(0.2), radius: 4)
                            Text ("\(pos.marketPrice)₽")
                                .frame(width: 250, height: 33, alignment: .leading)
                                .padding(.leading, -90)
                                .font(.system(size: 12))
                                .fontWeight(.light)
                                .foregroundColor(.black)
                        }
                        
                            ZStack {
                                Rectangle()
                                    .padding(1.0)
                                    .frame(width: 385, height: 110).foregroundColor(.white)
                                    .background(Color("CardBackground"))
                                    .cornerRadius(5)
                                    .shadow(color: Color.black.opacity(0.2), radius: 4)
                                
                                VStack {
                                    
                                    
                                    Text(pos.discriptionPosition)
                                        .frame(width: 385, height: 45, alignment: .topLeading)
                                        .padding(.leading, 50)
                                        .font(.system(size: 12))
                                        .fontWeight(.light)
                                        .foregroundColor(.black)
                                    
                                    
                                    ZStack {
                                        
                                        Rectangle()
                                        
                                            .padding(.leading, 7)
                                            .padding(.trailing, 7)
                                            .padding(.top, 0)
                                            .frame(width: 385, height: 30, alignment: .bottom).foregroundColor(.black)
                                            .background(Color("CardBackground"))
                                            .cornerRadius(5)
                                            .shadow(color: Color.black.opacity(0.2), radius: 4)
                                        
                                        Text (buttonText)
                                            .frame(width: 250, height: 30, alignment: .center)
                                            .font(.system(size: 14))
                                            .fontWeight(.light)
                                            .foregroundColor(.white)
                                    }.frame(width: 380, height: 40, alignment: .center)
                                }
                            }
                            
                        
                        Spacer()
                    }
                }
            }
        }
    }
}
