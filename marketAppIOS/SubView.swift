//
//  SubView.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 22.11.2023.
//

import Foundation
import SwiftUI

struct SubView: View {
    
    @StateObject var viewModel: SubviewModel = .init()
    
    @Binding var test: String?
    init(text: Binding<String?>) {
        self._test = text
    }
    
    var body: some View {
        Text(self.viewModel.subViewText ?? "no text")
            .onChange(of: self.test) {(text) in
                self.viewModel.updateText(text: text)
            }
            .onAppear(perform: { self.viewModel.updateText(text: test) })
    }
}
