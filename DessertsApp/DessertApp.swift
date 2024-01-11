//
//  ContentView.swift
//  DessertsApp
//
//  Created by siva on 1/9/24.
//

import SwiftUI

struct DessertApp: View {
    @StateObject private var dessertDataService = DessertDataService()
    @State var animationDone = false

    var body: some View {
        ZStack {
            // Background for all views
            Image("strawberries-and-cream-with-color")
                .resizable()
                .blur(radius: 10)
                .edgesIgnoringSafeArea(.all)
                .overlay(Color.black.opacity(0.4))
            Group{
                if (dessertDataService.isLoading || !animationDone ) {
                    IntroView(animationDone: $animationDone, error: dessertDataService.error)
                } else if( animationDone) {
                    ListView(desserts: dessertDataService.desserts)
                }
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: dessertDataService.desserts.isEmpty)
        .onAppear {
                    DispatchQueue.main.async {
                        dessertDataService.fetchDesserts()
                    }
        }
    }
}



#Preview {
    DessertApp()
}
