//
//  TestMainView.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 22.11.2023.
//

import Foundation
import SwiftUI

struct TestMainView: View {
    
    @StateObject var viewModel: ViewModel = .init()
    
    var body: some View {
        VStack {
            Button(action: { self.viewModel.didTapButton() }) {
                Text("TAP")
            }
            Spacer()
            menuViewF(text: $viewModel.testingID)
        }.frame(width: 300, height: 400)
    }
    
    
}


