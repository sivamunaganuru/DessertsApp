//
//  ListView.swift
//  DessertsApp
//
//  Created by siva on 1/9/24.
//

import SwiftUI


struct ListView: View {
    
    @StateObject private var dessertDataService = DessertDataService()
    
    var body: some View {
        NavigationView {
            ZStack {
                // List of desserts
                List(dessertDataService.desserts) { dessert in
                    NavigationLink(destination: DetailedView(dessert: dessert)) {
                        ListCellView(dessert: dessert)
                    }
                }
                .listStyle(PlainListStyle()) // Use plain style to allow full-width cells
                .onAppear {
                    dessertDataService.fetchDesserts()
                }
                .alert(item: $dessertDataService.error) { error in
                    Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
                            }
            }
            .navigationTitle("🎂 Desserts")
            .navigationBarTitleDisplayMode(.inline) // Makes title smaller and pushes it to the top
        }
        
    }
}



// Preview
struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

