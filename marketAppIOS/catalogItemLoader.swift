//
//  catalogItemLoader.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 24.11.2023.
//

import Foundation
import SwiftUI
import Firebase


class catalogItemLouder: ObservableObject {
    
  
    @Published var positions: [position] = []
   
    

    
    init () {
    
        positionLoader (_category: "TS")
        
    }
    

    
    func fetchPositions (category: String) {
        
    print("fetch")
        
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
                    
                   
                        
                        self.positions.append(marketPosition)
                    
                    print(self.positions[1].marketImg)
                
            }
        }
    }
}
   

    
    func loadLikeData () {
         
        print("likelouder")
       
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userUID = Auth.auth().currentUser?.uid
       
        var likeArray = [[String: String]]()
        var likeIDList: [String] = []
        var likeCategoryList: [String] = []
        
        
        ref.child("\(String(describing: userUID!)) LikeID").observeSingleEvent(of: .value, with: { [self] snapshot in
            
            var likeCount = snapshot.childrenCount
            
            let children = snapshot.children
            
            
            
                while let rest = children.nextObject() as? DataSnapshot, let value = rest.value {
                     likeArray.append(value as! [String: String])
                 }
        
            if likeArray.count != 0 {
                
                
                for i in 0 ... likeArray.count-1 {
                    
                    likeIDList.append(contentsOf: likeArray[i].values)
                }
                
                print (likeIDList)
                
                var setCategory =  Set<String>()
                
                for i in 0 ... likeIDList.count-1 {
                    
                    let aryChar = Array(likeIDList[i])
                    var category = "\(aryChar[0])\(aryChar[1])"
                    setCategory.insert(category)
                }
                
                
                for cat in setCategory {
                    
                    fetchPositions(category: cat)
                }
            }
         
        })
          // ...
        { error in
          print(error.localizedDescription)
        }
    }
}
