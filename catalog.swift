//
//  catalog.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 24.11.2023.
//

import Foundation
import SwiftUI
import Firebase


struct catalog: View {

    @EnvironmentObject var positionData: fireStoredataManager
    @State var basketQuantity = 0
    @State var openMenu = true
    @State var mode = -1
    @State var show = true
  
    
    private var adaptiveColumn = [
        
        GridItem (.adaptive(minimum: 170))
    ]
    
    var body: some View {
        @StateObject var ll = catalogItemLouder()
        
        if mode == 1 {ContentView(menuMode: 1)}
        
        if mode == 2  {ContentView(menuMode: 2)}
        
        if mode == 3  {ContentView(menuMode: 3)}
        
        if mode == 4  {ContentView(menuMode: 4)}
        
        
        
          let outerwear = catalogItem(picName: "outerwears", title: "Верхняя одежда",category: "OW")
          let shoes = catalogItem (picName: "shoes", title: "Обувь", category: "SH")
          let trousers = catalogItem (picName: "trousers", title: "Брюки", category: "TR")
          let costumes = catalogItem (picName: "costumes", title: "Пиджаки", category: "CO")
          let tshirts = catalogItem (picName: "tshirts", title: "Футболки", category: "TS")
          let jaket = catalogItem (picName: "jaket", title: "Джемперы", category: "JK")
          let jeans = catalogItem (picName: "jeans", title: "Джинсы", category: "JN")
      
          
      
          let items = [outerwear,shoes,trousers,costumes,tshirts,jaket,jeans]
        
        if show {
            
        NavigationView {
            
         
            
            ForEach (positionData.positions, id: \.id) { position in
             
                
                VStack {
                    NavigationLink(destination:  catalogITEM().environmentObject(ll)) {
                        HStack{
                            
                            
                            Image(items[1].picName)
                                .resizable()
                                .scaledToFit()
                                .frame(width:215.0, height:117.0, alignment: .leading)
                                .padding(0)
                            
                            Text (items[1].title)
                                .font(Font.custom("MyFont", size: 10, relativeTo: .title))
                                .foregroundColor(.black)
                                .frame(width:100.0, height:30.0, alignment: .leading)
                                .padding()
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        let aryChar = Array(position.id)
                        var category = "\(aryChar[0])\(aryChar[1])"
                        Text ("hi")
                        
                    }
                }
            }
            Text("hi")
         
                /*    ForEach (positionData.positions, id: \.id) { position in
                        
                        
                        HStack{
                            Image(items[1].picName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:215.0, height:117.0, alignment: .leading)
                                        .padding(0)
                            
                            Text (items[1].title)
                                    .font(Font.custom("MyFont", size: 10, relativeTo: .title))
                                    .foregroundColor(.black)
                                    .frame(width:100.0, height:30.0, alignment: .leading)
                                    .padding()
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        let aryChar = Array(position.id)
                        var category = "\(aryChar[0])\(aryChar[1])"
                        
                        VStack {
                            
                            Text (category)
                            
                            
                        }
                        
                    }
                 */
              
        }
        
        /*
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
         */
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

