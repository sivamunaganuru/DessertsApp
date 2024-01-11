//
//  ListView.swift
//  DessertsApp
//
//  Created by siva on 1/9/24.
//

import SwiftUI

struct ListView: View {
    var desserts: [DessertData]

    var body: some View {
        NavigationView {
            List(desserts) { dessert in

                    NavigationLink(destination: DetailedView(dessert: dessert)) {
                        ListCellView(dessert: dessert)
                    }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("🎂 Desserts")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}



// Preview
struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(desserts : DessertData.MockArray)
    }
}

