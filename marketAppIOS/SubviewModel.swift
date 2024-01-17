//
//  SubviewModel.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 22.11.2023.
//

import Foundation

class SubviewModel: ObservableObject {
    
    @Published var subViewText: String?
    
    func updateText(text: String?) {
        self.subViewText = text
        
    }
}
