//
//  ListCellView.swift
//  DessertsApp
//
//  Created by siva on 1/10/24.
//

import SwiftUI

struct ListCellView: View {
    var dessert : DessertData
    var body: some View {
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
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .gray, radius: 2, x: 0, y: 2)
        .listRowInsets(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}

#Preview {
    ListCellView(dessert: DessertData.MockData)
}
