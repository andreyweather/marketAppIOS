//
//  two.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 23.11.2023.
//

import Foundation
import SwiftUI

struct two: View {
    @Binding var isPresented: Bool

      var body: some View {
          Button("Dismiss") {
              isPresented = false
          }
      }
}
