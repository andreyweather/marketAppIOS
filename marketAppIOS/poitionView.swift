//
//  poitionView.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 13.11.2023.
//

import Foundation
import SwiftUI
import Firebase




struct positionView: View {
    
    
    var positionID: String = ""
    
    init (poitionId: String) {
        
        positionID = poitionId
    }
    
    var body: some View {
        
        VStack {
            Text (positionID)
        }
    }
    
}
