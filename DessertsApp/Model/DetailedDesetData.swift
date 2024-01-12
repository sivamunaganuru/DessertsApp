//
//  DetailedDesetData.swift
//  DessertsApp
//
//  Created by siva on 1/9/24.
//

import Foundation

struct DessertDetailedData: Decodable, Identifiable {
    var id: String { idMeal }
    let idMeal: String
    let strMeal: String
    let strInstructions: String
    let strMealThumb: String
    let ingredients: [String?]
    let measurements: [String?]
    
    // ... init(from decoder: Decoder) and CodingKeys as before ...
}

extension DessertDetailedData {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)

        // Initialize the arrays
        var ingredients = [String?]()
        var measurements = [String?]()

        // Decode each possible ingredient and measurement, up to 20
        for i in 1...20 {
            let ingredientKey = CodingKeys(rawValue: "strIngredient\(i)")
            let measurementKey = CodingKeys(rawValue: "strMeasure\(i)")

            if let ingredientKey = ingredientKey,
               let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey),
               !ingredient.isEmpty {
                ingredients.append(ingredient)
            } else {
                ingredients.append(nil)
            }

            if let measurementKey = measurementKey,
               let measurement = try container.decodeIfPresent(String.self, forKey: measurementKey),
               !measurement.isEmpty {
                measurements.append(measurement)
            } else {
                measurements.append(nil)
            }
        }

        self.ingredients = ingredients
        self.measurements = measurements
    }
    
    private enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strInstructions, strMealThumb
        case strIngredient1, strIngredient2, strIngredient3 ,strIngredient4,strIngredient5,strIngredient6,strIngredient7,strIngredient8,strIngredient9,strIngredient10,
             strIngredient11,strIngredient12,strIngredient13,strIngredient14,strIngredient15,strIngredient16,strIngredient17,strIngredient18,strIngredient19,strIngredient20
        
        case strMeasure1, strMeasure2, strMeasure3,strMeasure4,strMeasure5,strMeasure6,strMeasure7,strMeasure8,strMeasure9,strMeasure10,
             strMeasure11,strMeasure12,strMeasure13,strMeasure14,strMeasure15,strMeasure16,strMeasure17,strMeasure18,strMeasure19,strMeasure20
    }
}

extension DessertDetailedData {
    static let mockData = DessertDetailedData(
        idMeal: "52893",
        strMeal: "Apple & Blackberry Crumble",
        strInstructions: "Heat oven to 190C/170C fan/gas 5. Tip the flour and sugar into a large bowl. Add the butter, then rub into the flour using your fingertips to make a light breadcrumb texture. Do not overwork it or the crumble will become heavy. Sprinkle the mixture evenly over a baking sheet and bake for 15 mins or until lightly coloured.\r\nMeanwhile, for the compote, peel, core and cut the apples into 2cm dice. Put the butter and sugar in a medium saucepan and melt together over a medium heat. Cook for 3 mins until the mixture turns to a light caramel. Stir in the apples and cook for 3 mins. Add the blackberries and cinnamon, and cook for 3 mins more. Cover, remove from the heat, then leave for 2-3 mins to continue cooking in the warmth of the pan.\r\nTo serve, spoon the warm fruit into an ovenproof gratin dish, top with the crumble mix, then reheat in the oven for 5-10 mins. Serve with vanilla ice cream.",
        strMealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
        ingredients: [
            "Plain Flour", "Caster Sugar", "Butter", "Braeburn Apples",
            "Butter", "Demerara Sugar", "Blackberrys", "Cinnamon", "Ice Cream"
        ],
        measurements: [
            "120g", "60g", "60g", "300g",
            "30g", "30g", "120g", "\u{BC} teaspoon", "to serve"
        ]
    )
}

struct DessertDetailsResponse: Decodable {
    let meals: [DessertDetailedData]
}


class DessertDetailService: ObservableObject {
    @Published var detailedData: DessertDetailedData?
    @Published var isLoading = false
    @Published var error: IdentifiableError?
    
    func fetchDessertDetail(id: String) {
        isLoading = true
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else {
            self.error = IdentifiableError(message: "Invalid URL")
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = IdentifiableError(message:"Error fetching data: \(error.localizedDescription)")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = IdentifiableError(message: "Error response from server: \(String(describing: response))")
                }
                return
            }
            
            guard let mimeType = httpResponse.mimeType, mimeType == "application/json" else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = IdentifiableError(message: "Invalid MIME type: \(String(describing: httpResponse.mimeType))")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = IdentifiableError(message: "No data received")
                }
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(DessertDetailsResponse.self, from: data)
                //                    print("Decoded response: \(decodedResponse)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.detailedData = decodedResponse.meals.first
                    self.error = nil // Clear error message upon successful fetch
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = IdentifiableError(message: "Failed to decode JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
