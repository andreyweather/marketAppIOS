//
//  menuMode.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 16.11.2023.
//

import SwiftUI


struct test: View {
    
    @ObservedObject var Mode = menuMode()
    
    
    var body: some View {
        VStack {
            
            Text ("\(Mode.mode)")
        }
        
    }
}
