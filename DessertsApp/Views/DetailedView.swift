import SwiftUI

struct DetailedView: View {
    let dessert: DessertData
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
                                .padding(.horizontal)
                            Text(detailedData.strMeal)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.horizontal)

                    DescriptionView(detailedData: detailedData)
                    IngredientsView(detailedData: detailedData)
                }
            }
            .alert(item: $detailService.error) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
                        }
            .padding(.bottom)
            .onAppear {
                detailService.fetchDessertDetail(id: dessert.idMeal)
            }
        }
    }
}

struct DescriptionView: View {
    var detailedData : DessertDetailedData
    @State private var showFullDescription = false
    var body: some View {
        Group {
            Text(showFullDescription ? detailedData.strInstructions : String(detailedData.strInstructions.prefix(250)) + "...")
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(5)
                .padding()
                .background(Color(.systemBackground).opacity(0.6))
                .cornerRadius(8)
            
            Button(action: {
                withAnimation {
                    showFullDescription.toggle()
                }
            }) {
                Text(showFullDescription ? "Show Less" : "Read More")
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
            }
            .padding([.leading, .bottom])
        }
    }
}

struct IngredientsView: View {
    var detailedData : DessertDetailedData
    var body: some View {
        VStack(alignment: .leading) {
                    Text("Ingredients")
                        .font(.headline)
                        .padding([.horizontal,.bottom])

                    ForEach(Array(zip(detailedData.ingredients.indices, detailedData.ingredients)), id: \.0) { index, ingredient in
                        if let ingredient = ingredient, !ingredient.isEmpty {
                            HStack {
                                Text(ingredient)
                                    .foregroundColor(.secondary)
                                    .padding(.leading)
                
                                Spacer()
                                
                                Text(detailedData.measurements[index] ?? "")
                                    .foregroundColor(.secondary)
                                    .padding(.trailing)
                            }
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.bottom,2)
                }
                .padding(.horizontal)
    }
}


// Preview
struct DetailedView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedView(dessert: DessertData.MockData)
    }
}



