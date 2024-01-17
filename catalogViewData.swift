//
//  catalogViewData.swift
//  marketAppIOS
//
//  Created by andrey.pogodin on 24.11.2023.
//

import Foundation
import SwiftUI
import AVFAudio
import Firebase

struct catalogitemView: View {
    
    var item: catalogItem


    var body: some View {
        
        @StateObject var DataManager = fireStoredataManager(category: item.category)
        marketView(categoryTitle: item.title).environmentObject(DataManager)
        
    }
}
