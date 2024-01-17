//
//  ContentView.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 11.11.2023.
//

import SwiftUI
import AVFAudio
import Firebase
import FirebaseCore
import enkodpushlibrary


struct ContentView: View {
    
    @EnvironmentObject var positionData: fireStoreBasketLouder
    @State private var mode: Int 
    @State private var basketQuantity = 0
     
    
    init ( menuMode: Int) {
        
        mode = menuMode
        
    }
    
    var body: some View {
        
        
        switch mode {
            
        case 0:
            
            let screenSize = UIScreen.main.bounds.size
            VStack{
                
                autorizationView()
                
                
            }.frame(width: screenSize.width-10, height: screenSize.height-200,alignment: .bottom)
                .padding(.top, 15)
            
        case 1:
      
        
        catalogList()

            
        case 2:
            
            @StateObject var bl = fireStoreBasketLouder()
            basketView().environmentObject(bl)
           
            
            
        case 3:
            
            @StateObject var ll = fireStoreLikeLouder()
            likeView().environmentObject(ll)
          
            
        case 4:
            
            
            userView()
    
            
        case 5:
            
            Spacer()
            
        default:
            
            VStack{
                catalogList()
              
                
            }
            
        }
        
    }
    
}
      

    

