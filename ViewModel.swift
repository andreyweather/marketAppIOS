//
//  ViewModel.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 22.11.2023.
//

import Foundation
import SwiftUI
                


final class ViewModel: ObservableObject {
    
    @Published var testingID: String?
    var a = 0
      
    func didTapButton() {
        
        a=a+1
        self.testingID = String(a)
        
    }
    
}

