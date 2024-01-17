//
//  dbDataMenager.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 14.11.2023.
//

import Foundation

import SwiftUI
import Firebase


class dbDataMenager: ObservableObject {
    
  
    @Published var positions: [position] = []
    
    
    init (category: String) {
    
       var categoryFB = category
     fetchPositions(category: categoryFB)
        
    }
    
    func fetchPositions (category: String) {
        
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
                    
                }
            }
        }
    }
    
}
