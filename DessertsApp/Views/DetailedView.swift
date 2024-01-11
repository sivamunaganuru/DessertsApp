import SwiftUI

struct DetailedView: View {
    let dessert: DessertData
    @State private var showFullDescription = false
    @StateObject private var detailService = DessertDetailService()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if detailService.isLoading {
                    Text("Fetching Dessert Details from the server")
                        .font(.headline)
                    ProgressView()
                } else if let detailedData = detailService.detailedData {
                    
                    LoadAsyncImage(imageUrl: detailedData.strMealThumb)
                    .frame(height: 300)
                    .cornerRadius(12)
                    
                    Text(detailedData.strMeal)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Group {
                        Text(showFullDescription ? detailedData.strInstructions : String(detailedData.strInstructions.prefix(250)) + "...")
                        Button(showFullDescription ? "Show Less" : "Read More") {
                            showFullDescription.toggle()
                        }
                        .foregroundColor(.blue)
                    }
                    IngredientsView(detailedData: detailedData)
                }
            }
            .alert(item: $detailService.error) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
                        }
            .padding()
            .onAppear {
                detailService.fetchDessertDetail(id: dessert.idMeal)
            }
        }
    }
}
struct IngredientsView: View {
    var detailedData : DessertDetailedData
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ingredients")
                .font(.headline)
            
            ForEach(Array(zip(detailedData.ingredients.indices, detailedData.ingredients)), id: \.0) { index, ingredient in
                if let ingredient = ingredient, !ingredient.isEmpty {
                    HStack {
                        Text(ingredient)
                        Spacer()
                        Text(detailedData.measurements[index] ?? "")
                    }.foregroundColor(.secondary)
                }
            }
        }
    }
}


// Preview
struct DetailedView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedView(dessert: DessertData.MockData)
    }
}

