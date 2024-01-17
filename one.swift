//
//  one.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 23.11.2023.
//

import Foundation
import SwiftUI
struct one: View {
    
    @State private var showingAddUser = true

        var body: some View {
            VStack {
              Text ("hi")
            }
            .sheet(isPresented: $showingAddUser) {
                Text ("YES")
            }
        }
    
}
