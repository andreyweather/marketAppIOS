//
//  likeView.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 13.11.2023.
//

import Foundation
import SwiftUI
import Firebase


struct likeView: View {

    @EnvironmentObject var positionData: fireStoreLikeLouder
    @State var basketQuantity = 0
    @State var openMenu = true
    @State var mode = -1
    @State var show = true
    
    
    private var adaptiveColumn = [
        
        GridItem (.adaptive(minimum: 170))
    ]
    
    var body: some View {
        
        if mode == 1 {ContentView(menuMode: 1)}
        
        if mode == 2  {ContentView(menuMode: 2)}
        
        if mode == 3  {ContentView(menuMode: 3)}
        
        if mode == 4  {ContentView(menuMode: 4)}
        
        if show {
            
        NavigationView {
            
            ScrollView {
                
                LazyVGrid(columns: adaptiveColumn, spacing:0) {
                    ForEach (positionData.positions, id: \.id) { position in
                        
                        let aryChar = Array(position.id)
                        var category = "\(aryChar[0])\(aryChar[1])"
                        
                        // @StateObject var DataManager = fireStoreLikeLouder()
                        
                        
                        NavigationLink(destination:  positionFromLike(poitionId: position.id).navigationBarBackButtonHidden(true)) {
                            EmptyView()
                            ZStack {
                                Rectangle()
                                    .padding(1.0)
                                    .frame(width: 190, height: 210).foregroundColor(.white)
                                    .cornerRadius(5)
                                    .shadow(color: Color.black.opacity(0.2), radius: 4)
                                
                                VStack{
                                    
                                    AsyncImage (url: URL(string: position.marketImg)){ image in
                                        image.image?.resizable()
                                            .aspectRatio(contentMode: .fill)
                                        
                                    }
                                    
                                    Text (position.marketTitle)
                                        .font(.system(size: 14))
                                        .fontWeight(.light)
                                        .foregroundColor(.black)
                                        .frame(width: 150, height: 20, alignment: .center)
                                        .multilineTextAlignment(.center)
                                    Text ("\(position.marketPrice)₽").foregroundColor(.black)
                                        .font(.system(size: 12))
                                        .fontWeight(.ultraLight)
                                }.frame(width: 150, height: 190, alignment: .bottom)
                            }
                        }.simultaneousGesture(TapGesture().onEnded{
                            openMenu = false
                        })
                        
                    }
                }
                .padding(.horizontal, 5.0)
                
            }.navigationBarTitle("Избранное", displayMode: .inline)
        }
        
        
        if openMenu {
            
            HStack(spacing: 50){
                
                VStack{
                    
                    Button(action: {
                        
                        mode = 1
                        openMenu = false
                        show = false
                        
                        
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
                        openMenu = false
                        show = false
                        
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
                                    
                                    var basketQuantityString = String(basketQuantity)
                                    Text (basketQuantityString).font(Font.custom("MyFont", size: 12, relativeTo: .title)).foregroundColor(.black)
                                    
                                }.padding(.bottom, 15)
                                    .padding(.leading, 45)
                                
                            }
                            
                            if basketQuantity == 0 {
                                
                                ZStack {
                                    Image("blackcircle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18.0, height: 18.0, alignment: .bottom)
                                    
                                    var basketQuantityString = String(basketQuantity)
                                    Text (basketQuantityString).font(Font.custom("MyFont", size: 12, relativeTo: .title)).foregroundColor(.black)
                                    
                                }.padding(.bottom, 15)
                                    .padding(.leading, 45)
                                    .opacity(0)
        
                            }
                        }
                    }
                    
                    Text ("Корзина")
                        .font(Font.custom("MyFont", size: 10, relativeTo: .title))
                    
                    
                }.padding(.leading, 5)
                
                VStack {
                    Button(action: {
                        
                        mode = 3
                        openMenu = false
                        show = false
                        
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
                        openMenu = false
                        show = false
                        
                    }){
                        Image("user")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25.0, height: 25.0, alignment: .bottom)
                    }
                    Text ("Профиль")
                        .font(Font.custom("MyFont", size: 10, relativeTo: .title))
                }
                
            }.frame(width:400.0, height: 60.0, alignment: .bottom)
                .onAppear {
                    
                    
                    loadBasketData()
                    
                }
                .padding(.bottom, 0)
        }
    }
}
    
func loadBasketData () {
     

    var ref: DatabaseReference!
    ref = Database.database().reference()
    let userUID = UID
   
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





