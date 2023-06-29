//
//  FilterResultsView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/29.
//

import SwiftUI

class FilterResultsViewModel: ObservableObject {
    @AppStorage("Approved") var approved = true
    @AppStorage("MyFavourites") var myFavourites = true
    @AppStorage("MobileCompatible") var mobileCompatible = true
    
    func reset() {
        
    }
}

struct FilterResults: View {
    
    
    var body: some View {
        
    }
}
