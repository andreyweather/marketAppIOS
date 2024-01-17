//
//  basketIndicator.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 23.11.2023.
//

import Foundation
import SwiftUI



struct basketIndicator: View {
    
    @State var quantity  = 1
    
    init (_quantity: Int) {
        quantity = _quantity
    }
    
    
    var body: some View {
        ZStack {
            Image("blackcircle")
                .resizable()
                .scaledToFit()
                .frame(width: 18.0, height: 18.0, alignment: .bottom)
            var quantityString =  String(quantity)
            //var basketQuantityString = String(basketQuantity)
            Text (quantityString).font(Font.custom("MyFont", size: 12, relativeTo: .title)).foregroundColor(.black)
            
        }
    }
}
