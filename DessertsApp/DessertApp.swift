//
//  ContentView.swift
//  DessertsApp
//
//  Created by siva on 1/9/24.
//

import SwiftUI

struct DessertApp: View {
    var body: some View {
        TabView{
            ListView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
        }
        .accentColor(Color("MainColor"))
        
    }
}

#Preview {
    DessertApp()
}
