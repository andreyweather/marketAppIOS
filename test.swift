//
//  test.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 23.11.2023.
//

import Foundation
import SwiftUI

struct test: View {
    @State var showingAddUser = true
    var body: some View {
        
    
        one()
        two(isPresented: $showingAddUser)
        
        }
}
