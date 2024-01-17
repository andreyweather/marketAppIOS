//
//  userDataLoader.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 14.11.2023.
//

import Foundation
import SwiftUI
import Firebase


class userDataLoader: ObservableObject {
      
   
    
    
    init() {
        
       loadUserData()
        
    }
    
    func loadUserData () {


        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userUID = UID
        ref.child(userUID!).observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            
          let value = snapshot.value as? NSDictionary
          let id = value?["id"] as? String ?? ""
          let account = value?["account"] as? String ?? ""
          let email = value?["email"] as? String ?? ""
          let phone = value?["phone"] as? String ?? ""
            
            let user = userData(id: id, acount: account, email: email, phone: phone)
            
            self.users.append(user)
            
        print(user)
          // ...
        }) { error in
          print(error.localizedDescription)
            
        }
    }
}

