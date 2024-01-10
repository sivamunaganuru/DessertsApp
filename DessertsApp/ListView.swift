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
                        HStack(spacing: 20) {
                            LoadAsyncImage(imageUrl: dessert.strMealThumb)
                                .frame(width: 100, height: 100)
                                .mask(RoundedRectangle(cornerRadius: 16))
                                .padding(.leading)
                            Text(dessert.strMeal)
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white) // Or the color you want for each cell
                        .cornerRadius(8)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2) // Optional: for better separation
                        .listRowInsets(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
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


