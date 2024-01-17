//
//  positionView.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 13.11.2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore


    struct positionView: View {
        
        @EnvironmentObject var positionData: fireStoredataManager
        
        
        var positionID: String = ""
        
        init (positionId: String) {
            
            positionID = positionId
            
        }
        
         @State var likeMode = false
         @State var inBasket = true
         @State var confirm = false
         @State var afterConfirm = false
         
         @State var buttonText = "ДОБАВИТЬ В КОРЗИНУ"
         @State var confirmBottonText = "ДОБАВИТЬ"
         @State var remove = "УБРАТЬ"
         @State var buy = "КУПИТЬ"
         @State var specifyTheQuantity = "УКАЖИТЕ КОЛИЧЕСТВО"
         @State var productCount = 1
         @State var ok = false
        

        
        var userUID = UID
    
        
        
        var body: some View {
            

            VStack {
                
                ForEach (positionData.positions, id: \.id) { pos  in
                    
                    
         
                    
                    if pos.id == positionID {
                        

                        let field: [String:Any] = ["price": "\(pos.marketPrice)"]
            
                        
                        let product = Product_N(
                            
                            id: pos.id,
                            count: 1,
                            categoryId:"",
                            fields: field
                            
                        )
                        
                 
                        
                
                     
                        VStack{
                            ZStack {
                                
                                Rectangle()
                                
                                    .padding(1.0)
                                    .frame(width: 385, height: 320).foregroundColor(.white)
                                    .cornerRadius(5)
                                    .shadow(color: Color.black.opacity(0.2), radius: 4)
                                
                                HStack{
                                    AsyncImage (url: URL(string: pos.marketImg)){ image in
                                        image.image?.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .scaledToFit()
                                    
                                    }
                                }.frame(width: 230, height: 260, alignment: .center)
                                
                                
                                HStack{
                                    
                                    if !afterConfirm {
                                        
                                    
                                        Image("inbasket")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 32.0, height: 35.0, alignment: .top)
                                            .padding(.top, 20)
                                            .padding(.leading, 0)
                                        
                                    }
                                        
                                    if afterConfirm {
                                            
                                            Image("addbasket")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 32.0, height: 35.0, alignment: .top)
                                                .padding(.top, 20)
                                                .padding(.leading, 0)
                                    }
                                    
                                    Spacer()
                                    Button(action: {
                                        
                                        
                                        likeMode = true
                                        
                                        var ref: DatabaseReference!
                                        ref = Database.database().reference()
                                        
                                        ref.child("\(String(describing: userUID!)) LikeID").child(pos.id).setValue(["id": pos.id])
                                        
                                            
                                            do {
                                                try AddToFavourite(product: product)

                                                   } 
                                                catch {
                                                    print("Error")
                                                      }
                                        
                                    
                                     
                                        
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
                                        
                                        do {
                                            
                                                try RemoveFromFavourite(product: product)

                                               } catch {
                                                print("Error")
                                               }
                                        
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
                                    .padding(.top, 5)
                                    .frame(width: 385, height: 40).foregroundColor(.white)
                                    .cornerRadius(5)
                                    .shadow(color: Color.black.opacity(0.2), radius: 4)
                                
                                if !confirm  && !afterConfirm {
                                    
                                    HStack {
                                        Text ("\(pos.marketPrice)₽")
                                            .frame(width: 65, height: 33, alignment: .leading)
                                            .padding(.leading, -12)
                                            .font(.system(size: 12))
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                        
                                        Text ("").frame(width: 250, height: 33, alignment: .leading)
                                        
                                    }
                                }
                           
                                if confirm || afterConfirm {
                                    
                                HStack {
                                    Text ("\(pos.marketPrice)₽")
                                        .frame(width: 65, height: 33, alignment: .leading)
                                        .padding(.leading, 30)
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        
                                    
                                   
                                        HStack(spacing: 16) {
                                            Text ("X").font(.system(size: 12))
                                            
                                            Text ("\(productCount)").font(.system(size: 12)).fontWeight(.semibold)
                                            
                                            Text ("=").font(.system(size: 12))
                                            
                                            Text ("\(productCount*(Int(pos.marketPrice) ?? 1))₽").font(.system(size: 12)).fontWeight(.semibold)
                                            
                                        }.frame(width: 130, height: 33, alignment: .leading)
                                    
                                        
                                        Spacer()
                                        HStack {
                                            Button(action: {
                                                
                                                if productCount > 1{
                                                    
                                                    productCount += -1
                                                    
                                                }
                                                
                                                var ref: DatabaseReference!
                                                ref = Database.database().reference()
                                                var quantity = String(productCount)
                                                let quantityModel = ["id": pos.id, "quantity": quantity]
                                                ref.child("\(String(describing: userUID!)) Quantity").child(pos.id).setValue(quantityModel)
                                                
                                            }){
                                                
                                                
                                                Image("minus")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 21.0, height: 21.0, alignment: .top)
                                                    .padding(.trailing, 0)
                                                
                                            }
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                
                                                productCount += 1
                                                var ref: DatabaseReference!
                                                ref = Database.database().reference()
                                                var quantity = String(productCount)
                                                let quantityModel = ["id": pos.id, "quantity": quantity]
                                                ref.child("\(String(describing: userUID!)) Quantity").child(pos.id).setValue(quantityModel)
                                                
                                            }){
                                                
                                                
                                                Image("plus")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 18.4, height: 18.4, alignment: .top)
                                                    .padding(.trailing, 0)
                                                
                                            }
                                        }.padding(.trailing, 41)
                                            .frame(width: 100, height: 33, alignment: .trailing)
                                    }
                                }
                                
                                if confirm || afterConfirm {
                                    Image("line")
                                        .resizable()
                                        .frame(width: 380.0, height: 2.0, alignment: .bottom)
                                        .padding(.top, 35)
                                        
                                }
                            }
                            
                            ZStack {
                                Rectangle()
                                    .padding(1.0)
                                    .frame(width: 385, height: 140).foregroundColor(.white)
                                    .cornerRadius(5)
                                    .shadow(color: Color.black.opacity(0.2), radius: 4)
                                
                                VStack {
                                    
                                    if inBasket {
                                        
                                        Text(pos.discriptionPosition)
                                            .frame(width: 385, height: 75, alignment: .topLeading)
                                            .padding(.leading, 50)
                                            .padding(.top, 7)
                                            .font(.system(size: 12))
                                            .fontWeight(.light)
                                            .foregroundColor(.black)
                                        
                                        Button(action: {
                                            
                                            
                                            confirm = true
                                            
                                            
                                            inBasket = false
                                            
                                            
                                            
                                        }){
                                            
                                            ZStack {
                                                Rectangle()
                                                
                                                    .padding(.leading, 7)
                                                    .padding(.trailing, 7)
                                                    .padding(.top, 0)
                                                    .frame(width: 385, height: 30, alignment: .bottom).foregroundColor(.black)
                                                    .cornerRadius(5)
                                                    .shadow(color: Color.black.opacity(0.2), radius: 4)
                                                
                                                Text (buttonText)
                                                    .frame(width: 250, height: 30, alignment: .center)
                                                    .font(.system(size: 14))
                                                    .fontWeight(.light)
                                                    .foregroundColor(.white)
                                            }.frame(width: 400, height: 40, alignment: .center)
                                            
                                        }
                                    }
                                    
                                    if confirm {
                                        
                                        if !ok {
                                            VStack {
                                                Image("uparrowtwo")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .padding(.top, 5)
                                                    .frame(width: 30.0, height: 45.0, alignment: .bottom)
                                                Text (specifyTheQuantity).font(.system(size: 10)).fontWeight(.light)
                                            }.frame(width: 380, height: 85, alignment: .center)
                                        }
                                        
                                        if ok {
                                            
                                            VStack {
                                                Image("checkmark")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .padding(.top, 5)
                                                    .frame(width: 30.0, height: 45.0, alignment: .bottom)
                                                
                                            }.frame(width: 380, height: 85, alignment: .center)
                                            
                                        }
                                        
                                        Button(action: {
                                            
                                            ok = true
                                            
                                            var ref: DatabaseReference!
                                            ref = Database.database().reference()
                                            ref.child("\(String(describing: userUID!)) BasketID").child(pos.id).setValue(["id": pos.id])
                                            
                                            
                                            let quantity = String(productCount)
                                            let quantityModel = ["id": pos.id, "quantity": quantity]
                                            ref.child("\(String(describing: userUID!)) Quantity").child(pos.id).setValue(quantityModel)
                                            
                                            let product = Product_N(
                                                
                                                id: pos.id,
                                                count: productCount,
                                                categoryId:"",
                                                fields: field
                                                
                                            )
                                            
                                            do {
                                                
                                                
                                                    try AddToCart(product: product)

                                                   } catch {
                                                    print("Error")
                                                   }
                                         
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                
                                                ok = false
                                                afterConfirm = true
                                                confirm = false
                                                
                                            }
                                            
                                        }){
                                            
                                            ZStack {
                                                
                    
                                                if (ok) {
                                                    
                                                    Rectangle()
                                                    
                                                        .padding(.leading, 7)
                                                        .padding(.trailing, 7)
                                                        .padding(.top, 0)
                                                        .frame(width: 385, height: 30, alignment: .bottom).foregroundColor(.green)
                                                        .cornerRadius(5)
                                                        .shadow(color: Color.black.opacity(0.2), radius: 4)
                                                }
                                                
                                                if (!ok) {
                                                    
                                                    Rectangle()
                                                    
                                                        .padding(.leading, 7)
                                                        .padding(.trailing, 7)
                                                        .padding(.top, 0)
                                                        .frame(width: 385, height: 30, alignment: .bottom).foregroundColor(.black)
                                                        .cornerRadius(5)
                                                        .shadow(color: Color.black.opacity(0.2), radius: 4)
                                                }
                                                
                                                Text (confirmBottonText)
                                                    .frame(width: 250, height: 30, alignment: .center)
                                                    .font(.system(size: 14))
                                                    .fontWeight(.light)
                                                    .foregroundColor(.white)
                                            }.frame(width: 380, height: 40, alignment: .center)
                                            
                                        }
                                    }
                                    
                                    if afterConfirm {
                                        
                                        VStack {
                                            
                                            Text(pos.discriptionPosition)
                                                .frame(width: 385, height: 65, alignment: .topLeading)
                                                .padding(.leading, 50)
                                                .padding(.top, 0)
                                                .font(.system(size: 12))
                                                .fontWeight(.light)
                                                .foregroundColor(.black)
                                            
                                        }.frame(width: 380, height: 85, alignment: .center)
                                        
                                        Button(action: {
                                            
                                            afterConfirm = true
                                            confirm = false
                                            
                                        }){
                                            
                                            HStack {
                                                
                                                Button(action: {
                                                    
                                                    
                                                    afterConfirm = false
                                                    inBasket = true
                                                

                                                    var ref: DatabaseReference!
                                                    ref = Database.database().reference()
                                                    ref.child("\(String(describing: userUID!)) BasketID").child(pos.id).removeValue()
                                                    ref.child("\(String(describing: userUID!)) Quantity").child(pos.id).removeValue()
                                                    
                                                    
                                                    let product = Product_N(
                                                        
                                                        id: pos.id,
                                                        count: productCount,
                                                        categoryId:"",
                                                        fields: field
                                                        
                                                    )
                                                    
                                                    do {
                                                        
                                                        
                                                            try RemoveFromCart (product: product)

                                                           } catch {
                                                            print("Error")
                                                           }
                                                    
                                                    
                                                    
                                                }){
                                                    ZStack {
                                                        Rectangle()
                                                        
                                                            .padding(.leading, 10)
                                                            .padding(.trailing, 0)
                                                            .padding(.top, 0)
                                                            .frame(width: 188, height: 30, alignment: .bottomLeading).foregroundColor(.black)
                                                            .cornerRadius(0)
                                                            .shadow(color: Color.black.opacity(0.2), radius: 4)
                                                        
                                                        Text (remove)
                                                            .frame(width: 188, height: 30, alignment: .center)
                                                            .font(.system(size: 14))
                                                            .fontWeight(.light)
                                                            .foregroundColor(.white)
                                                        
                                                        
                                                    }.frame(width: 188, height: 30, alignment: .bottomLeading)
                                                }.frame(width: 188, height: 30, alignment: .bottomLeading)
                                                
                                                
                                                Button(action: {
                                                    
                                                    let uuid = UUID().uuidString
                                                    let marketPrice: Double? = Double(pos.marketPrice)
                                                    
                                                    let order = Order_N (
                                                         
                                                        orderId: uuid,
                                                        productId: pos.id,
                                                        sum: 1000.0,
                                                        price: marketPrice,
                                                        fields: ["count": 2]
                                                        
                                                      )
                                                    
                                                   
                                                    do {

                                                            try productBuy_N(order: order)

                                                           } catch {
                                                            print("Error")
                                                           }
                                                     
                                                    
                                                }){
                                                    ZStack {
                                                        Rectangle()
                                                        
                                                            .padding(.leading, 0)
                                                            .padding(.trailing, 5)
                                                            .padding(.top, 0)
                                                            .frame(width: 188, height: 30).foregroundColor(.black)
                                                            .cornerRadius(0)
                                                            .shadow(color: Color.black.opacity(0.2), radius: 4)
                                                        
                                                        Text (buy)
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
                            
                            Spacer()
                        }
                    }
                }
            }.onAppear {
                
                

                
                let field: [String:Any] = ["price": ""]
                
                let product = Product_N(
                    
                    
                    id: positionID,
                    count: 1,
                    categoryId:"",
                    fields: field
                    
                )
        
           
                do {
                        try ProductOpen(product: product)

                       } catch {
                        print("Error")
                       }
                
                likeCheck(positionID: positionID)
                basketCheck(positionID: positionID)
                quantityCheck(positionID: positionID)
                
            }
        }
        
        func likeCheck (positionID: String) {
         
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let userUID = UID
            
            var likeArray = [[String: String]]()
            var likeIDList: [String] = []
            
            
            
            ref.child("\(String(describing: userUID!)) LikeID").observeSingleEvent(of: .value, with: {snapshot in
                
              
                
                let children = snapshot.children
                
                while let rest = children.nextObject() as? DataSnapshot, let value = rest.value {
                    likeArray.append(value as! [String: String])
                }
                
                if likeArray.count != 0 {
                    for i in 0 ... likeArray.count-1 {
                    
                    likeIDList.append(contentsOf: likeArray[i].values)
                }
                
                if likeIDList.contains(positionID) {
                    print("contain")
                    likeMode = true
                    
                }
                
                
                var setCategory =  Set<String>()
                
                for i in 0 ... likeIDList.count-1 {
                    
                    let aryChar = Array(likeIDList[i])
                    let category = "\(aryChar[0])\(aryChar[1])"
                    setCategory.insert(category)
                }
            }
            
            })
            // ...
            { error in
                
                print(error.localizedDescription)
            }
        }
        
        func basketCheck (positionID: String) {
         
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let userUID = UID
            
            var basketArray = [[String: String]]()
            var basketIDList: [String] = []
           

            
            ref.child("\(String(describing: userUID!)) BasketID").observeSingleEvent(of: .value, with: {snapshot in
                
                
                let children = snapshot.children
                
                while let rest = children.nextObject() as? DataSnapshot, let value = rest.value {
                    basketArray.append(value as! [String: String])
                }
                
                if basketArray.count != 0 {
                    
                    for i in 0 ... basketArray.count-1 {
                        
                        basketIDList.append(contentsOf: basketArray[i].values)
                    }
                    
                    if basketIDList.contains(positionID) {
                        print("contain")
                        
                        inBasket = false
                        afterConfirm = true
                        
                    }
                    
                    var setCategory =  Set<String>()
                    
                    for i in 0 ... basketIDList.count-1 {
                        
                        let aryChar = Array(basketIDList[i])
                        let category = "\(aryChar[0])\(aryChar[1])"
                        setCategory.insert(category)
                    }
                }
            })
            // ...
            { error in
                print(error.localizedDescription)
            }
        }
        
        func quantityCheck (positionID: String) {
         
            print("quantityArray")
            
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let userUID = UID
            
            var quantityArray = [[String: String]]()
            var quantityIDList: [String] = []
           

            ref.child("\(String(describing: userUID!)) Quantity").observeSingleEvent(of: .value, with: {snapshot in
                
                let children = snapshot.children
                print(snapshot)
                
                
                while let rest = children.nextObject() as? DataSnapshot, let value = rest.value {
                    quantityArray.append(value as! [String: String])
                }
                
                
                print(quantityArray)
                
                if quantityArray.count != 0 {
                    
                    for i in 0 ... quantityArray.count-1 {
                        
                        quantityIDList.append(contentsOf: quantityArray[i].values)
                    }
                    
                                    
                    if quantityIDList.contains(positionID) {
                        print("contain")
                        
                        var index = 0
                        var quantity = 0

                        for i in 0 ... quantityArray.count-1 {
                            
                            var elemetInArr = quantityArray[i]
                            
                           // print (elemetInArr)
                            
                           if elemetInArr["id"] == positionID {
                               
                               quantity = Int(elemetInArr["quantity"]!) ?? 1
      
                            }
                        }

                        productCount = quantity
                    }
                }
            })
        
            { error in
                print(error.localizedDescription)
            }
        }
    }

