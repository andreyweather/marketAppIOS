//
//  catalogView.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 13.11.2023.
//

import Foundation
import SwiftUI
import AVFAudio
import Firebase



private var uid_pref: String {return "UID"}

var UID: String? { return UserDefaults.standard.object(forKey: uid_pref) as? String }

struct catalogItem: Identifiable {
    
    var id = UUID ()
    var picName: String
    var title: String
    var category: String
    
}

struct menuItem: Identifiable {
    var id = UUID ()
    var picName: String
    var title: String
}


struct catalogitemView: View {
    
    var item: catalogItem


    var body: some View {
        
        @StateObject var DataManager = fireStoredataManager(category: item.category)
        marketView(categoryTitle: item.title).environmentObject(DataManager)
    }
}


struct catalogItemRaw: View {
    var item: catalogItem
    var body: some View {
        HStack{
            Image(item.picName)
                        .resizable()
                        .scaledToFit()
                        .frame(width:215.0, height:117.0, alignment: .leading)
                        .padding(0)
            
            Text (item.title)
                    .font(Font.custom("MyFont", size: 10, relativeTo: .title))
                    .foregroundColor(.black)
                    .frame(width:100.0, height:30.0, alignment: .leading)
                    .padding()
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}



struct catalogList: View {
    
    
    
    @State var openMenu = true
    @State var basketQuantity = 0
    @State var mode = -1
    @State var show = true
    
    
    
    var body: some View {
        
      
        let outerwear = catalogItem(picName: "outerwears", title: "Верхняя одежда",category: "OW")
        let shoes = catalogItem (picName: "shoes", title: "Обувь", category: "SH")
        let trousers = catalogItem (picName: "trousers", title: "Брюки", category: "TR")
        let costumes = catalogItem (picName: "costumes", title: "Пиджаки", category: "CO")
        let tshirts = catalogItem (picName: "tshirts", title: "Футболки", category: "TS")
        let jaket = catalogItem (picName: "jaket", title: "Джемперы", category: "JK")
        let jeans = catalogItem (picName: "jeans", title: "Джинсы", category: "JN")
    
        
    
        let items = [outerwear,shoes,trousers,costumes,tshirts,jaket,jeans]
        
        
     

        if  mode == 1 {ContentView(menuMode: 1)}

        if mode == 2  {ContentView(menuMode: 2)}
            
        if mode == 3  {ContentView(menuMode: 3)}
              
        if mode == 4  {ContentView(menuMode: 4)}
            
            
        if openMenu {
            
        NavigationView{
            List (items) {item  in
                NavigationLink(destination: catalogitemView(item: item).navigationBarBackButtonHidden(true)) {
                    
                
                    catalogItemRaw(item: item)
                    
                }
                
               
                
                //.listRowInsets(EdgeInsets())
                .listRowInsets(.init())
                .border(Color.white, width: 1)
            }
            .padding(.horizontal, -20)
                .padding(.top, -40)
                .onAppear(perform: {
                    
                    UITableView.appearance().contentInset.top = -35
                    
                })
            
                .navigationBarTitle("Категории", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
            
            
        }
            
            if show {
                
                HStack(spacing: 50){
                    
                    
                    VStack{
                        
                        Button(action: {
                            
                            
                            
                            
                            mode = 1
                            openMenu = false
                            
                            
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
        
       
        var basketArray = [[String: String]]()
       
        
        ref.child("\(String(describing: UID!)) BasketID").observeSingleEvent(of: .value, with: {  snapshot in
            
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
