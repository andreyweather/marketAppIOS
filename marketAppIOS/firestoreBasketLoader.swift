//
//  firestoreBasketLoader.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 21.11.2023.
//


import Foundation
import SwiftUI
import Firebase


class fireStoreBasketLouder: ObservableObject {
    
  
    @Published var positions: [position] = []
   


    
    init () {
    
        loadBasketData ()
        
    }
    

    
    func fetchPositions (category: String, baketIDList: [String]) {
        
        
        positions.removeAll()
        let db = Firestore.firestore()
            let ref = db.collection(category)
        ref.getDocuments {
            snapshot,  Error in
            guard Error == nil else {
                print (Error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["marketId"] as? String ?? ""
                    let marketImg = data["marketImg"] as? String ?? ""
                    let marketPrice = data["marketPrice"] as? String ?? ""
                    let marketTitle = data["marketTitle"] as? String ?? ""
                    let brandPosition = data["brandPosition"] as? String ?? ""
                    let namePosition = data["namePosition"] as? String ?? ""
                    let discriptionPosition = data["discriptionPosition"] as? String ?? ""
                    
                    
            
                    let marketPosition = position (id: id, marketImg: marketImg, marketPrice: marketPrice, marketTitle: marketTitle, brandPosition: brandPosition, namePosition: namePosition, discriptionPosition: discriptionPosition)
                    
                    if baketIDList.contains(marketPosition.id){
                        
                        self.positions.append(marketPosition)
                }
            }
        }
    }
}
   

    
    func loadBasketData () {
         
        print("likelouder")
       
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userUID = UID
       
        var basketArray = [[String: String]]()
        var basketIDList: [String] = []
        var basketCategoryList: [String] = []
        
        
        ref.child("\(String(describing: userUID!)) BasketID").observeSingleEvent(of: .value, with: { [self] snapshot in
            
            var basketCount = snapshot.childrenCount
            
            let children = snapshot.children
            
            
            
                while let rest = children.nextObject() as? DataSnapshot, let value = rest.value {
                     basketArray.append(value as! [String: String])
                 }
        
            if basketArray.count != 0 {
                
                
                for i in 0 ... basketArray.count-1 {
                    
                    basketIDList.append(contentsOf: basketArray[i].values)
                }
                
                print (basketIDList)
                
                var setCategory =  Set<String>()
                
                for i in 0 ... basketIDList.count-1 {
                    
                    let aryChar = Array(basketIDList[i])
                    var category = "\(aryChar[0])\(aryChar[1])"
                    setCategory.insert(category)
                }
                
                
                for cat in setCategory {
                    
                    fetchPositions(category: cat, baketIDList: basketIDList)
                }
            }
         
        })
          // ...
        { error in
          print(error.localizedDescription)
        }
    }
}
