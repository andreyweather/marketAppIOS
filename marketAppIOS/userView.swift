//
//  userView.swift
//  marketApp
//
//  Created by andrey.pogodin on 06.11.2023.
//

import Foundation
import SwiftUI
import Firebase

struct userView: View {
    
    
    var userUID = UID
    
    private var account_pref: String {return "ACCOUNT"}
    private var uid_pref: String {return "UID"}
    private var session_pref: String { return "SESSION_ID" }
    private var token_pref: String { return "TOKEN" }
    private var email_pref: String { return "EMAIL" }
    private var phone_pref: String { return "PHONE" }
    
    
    
    var account: String? {return UserDefaults.standard.object(forKey: account_pref) as? String }
    
    @State var logOut = false
    @State var openMenu = true
    @State var basketQuantity = 0
    @State var mode = -1
    @State var show = true
    @State  var email:String = ""
    @State  var phone:String = ""
    @State var addContact: Bool = false
    
    
    var body: some View {
        
        
        if mode == 1  {ContentView(menuMode: 1)}
        
        if mode == 2  {ContentView(menuMode: 2)}
        
        if mode == 3  {ContentView(menuMode: 3)}
        
        if mode == 4  {ContentView(menuMode: 4)}
        
        
        if (logOut) {
            
            ContentView(menuMode: 0)
            
        }
        
        if (!logOut){
            
            if openMenu {
                
                ZStack {
                    
                    
                    let screenSize = UIScreen.main.bounds.size
                    var getToken: String? { return UserDefaults.standard.object(forKey: token_pref) as? String }
                    var getSessionID: String? { return UserDefaults.standard.object(forKey: session_pref) as? String }
                    var getEmail:String? { return UserDefaults.standard.object(forKey: email_pref) as? String }
                    var getPhone:String? { return UserDefaults.standard.object(forKey: phone_pref) as? String }
                    
                    Rectangle()
                    
                        .padding(1.0)
                        .frame(width: screenSize.width-10, height: screenSize.height-200).foregroundColor(.white)
                        .background(Color("CardBackground"))
                        .cornerRadius(5)
                        .shadow(color: Color.black.opacity(0.2), radius: 4)
                    
                    VStack() {
                        
                        
                        Text ("account: \(account ?? "")")
                            .frame(width: 350, height: 33, alignment: .leading)
                            .font(.title3)
                        Text ("session: \(getSessionID ?? "")")
                            .frame(width: 350, height: 23, alignment: .leading)
                            .font(.system(size: 14))
                        Text ("token: \(getToken ?? "")")
                            .frame(width: 350, height: 99, alignment: .topLeading)
                            .font(.system(size: 14))
                        
                        if (addContact || getEmail != nil || getPhone != nil) {
                            
                            if (getEmail != nil) {
                                Text ("email: \(getEmail ?? "")")
                                    .frame(width: 350, height: 23, alignment: .leading)
                                    .font(.system(size: 14))
                                    .onAppear {
                                      
                                        addContact = true
                                        
                                    }
                            }
                            
                            if (getPhone != nil) {
                                Text ("phone: \(getPhone ?? "")")
                                    .frame(width: 350, height: 23, alignment: .leading)
                                    .font(.system(size: 14))
                                    .onAppear {
                                        
                                        addContact = true
                                        
                                    }
                            }
                            
                        }
                    
                        Spacer()
                        
                        if !addContact {
                            
                            VStack(spacing: 40){
                                
                                
                                TextField("Email", text: $email)
                                    .padding(0.0)
                                    .frame(width: 350.0,height: 1, alignment: .bottom)
                                    .padding(.horizontal)
                                    .background(Color.black)
                                
                                TextField("Phone", text: $phone)
                                    .padding(0.0)
                                    .frame(width: 350.0, height: 1, alignment: .bottom)
                                    .padding(.horizontal)
                                    .background(Color.black)
                                
                                
                                
                            }
                            .padding(.top, 15.0)
                            .frame(width: 383, height: 165,alignment: .center)
                        }
                        
                        HStack {
                            
                            Button(action: {
                                
                                UserDefaults.standard.set("", forKey: account_pref)
                                UserDefaults.standard.removeObject(forKey: uid_pref)
                               
                                
                                                            marketAppIOS.logOut()
                                    
                                                            logOut = true
                                                            show = false
                                
                            }){
                                ZStack {
                                    Rectangle()
                                    
                                        .padding(.leading, 10)
                                        .padding(.trailing, 0)
                                        .padding(.top, 0)
                                        .frame(width: 188, height: 30, alignment: .bottomLeading).foregroundColor(.black)
                                        .cornerRadius(0)
                                        .shadow(color: Color.black.opacity(0.2), radius: 4)
                                    
                                    Text ("Сменить профиль")
                                        .frame(width: 188, height: 30, alignment: .center)
                                        .font(.system(size: 14))
                                        .fontWeight(.light)
                                        .foregroundColor(.white)
                                    
                                    
                                }.frame(width: 188, height: 30, alignment: .bottomLeading)
                            }.frame(width: 188, height: 30, alignment: .bottomLeading)
                            
                            
                            Button(action: {
                                
                                var user  = [String:Any] ()
                                
                                if (email != "" && phone != "" )  {
                                    
                                    user = ["fields": ["email": email, "phone": phone, "firstName": "AndreyWeather"]]
                                    
                                    UserDefaults.standard.set(email, forKey: email_pref)
                                    UserDefaults.standard.set(phone, forKey: phone_pref)
                                
                                }
                                
                                if (email != "" && phone == "") {
                                    
                                     user = ["fields": ["email": email]]
                                     UserDefaults.standard.set(email, forKey: email_pref)
                                
                                }
                                
                                if (email == "" && phone != "") {
                                    
                                     user = ["fields": ["phone": phone]]
                                     UserDefaults.standard.set(phone, forKey: phone_pref)
                                    
                                }
                                
                                if (email != "" || phone != "") {
                                    
                                    do {

                                           try subscribeNew_N(subscriberInfo: user)
                                                      
                                          } catch {
                                              
                                             print("Error")
                                      }
                                    
                                }
                                
                                
                                
                                addContact = true
                                
                            }){
                                ZStack {
                                    Rectangle()
                                    
                                        .padding(.leading, 0)
                                        .padding(.trailing, 5)
                                        .padding(.top, 0)
                                        .frame(width: 188, height: 30).foregroundColor(.black)
                                        .cornerRadius(0)
                                        .shadow(color: Color.black.opacity(0.2), radius: 4)
                                    
                                    Text ("Добавить контакт")
                                        .frame(width: 188, height: 30, alignment: .center)
                                        .font(.system(size: 14))
                                        .fontWeight(.light)
                                        .foregroundColor(.white)
                                    
                                }.frame(width: 188, height: 30)
                            }.frame(width: 188, height: 30)
                            
                        }.frame(width: 380, height: 40, alignment: .center)
                    }
                    
                }
                
            }
        }
        
        
        if show {
            
            Spacer()
            
            HStack(spacing: 50){
                
                
                VStack{
                    
                    Button(action: {
                        
                        
                        
                        
                        mode = 1
                        show = false
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
                        show = false
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
                                    
                                    let basketQuantityString = String(basketQuantity)
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
                                    
                                    let basketQuantityString = String(basketQuantity)
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
                        show = false
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
                        show = false
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
                .padding(.top, 44)
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



struct  userView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
          userView()
            
      }
    }
  }


