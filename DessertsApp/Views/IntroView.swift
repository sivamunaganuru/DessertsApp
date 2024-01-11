//
//  IntroView.swift
//  DessertsApp
//
//  Created by Siva Munaganuru on 1/11/24.
//

import SwiftUI
struct IntroView: View {
    @Binding var animationDone: Bool
    var error: IdentifiableError?
    @State private var welcomeOpacity = 0.0
    @State private var indulgeOpacity = 0.0
    @State private var fetchingOpacity = 0.0

    var body: some View {
        VStack {
            Text("Welcome to Dessert Recipe")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .opacity(welcomeOpacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 2)) {
                        welcomeOpacity = 1.0
                    }
                }

            if welcomeOpacity == 1.0 {
                Text("Indulge in the sweetness!")
                    .font(.title)
                    .foregroundColor(.white)
                    .opacity(indulgeOpacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeIn(duration: 2)) {
                                indulgeOpacity = 1.0
                            }
                        }
                    }
            }

            if indulgeOpacity == 1.0 {
                Text("Fetching your favorite desserts...")
                    .font(.headline)
                    .foregroundColor(.white)
                    .opacity(fetchingOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1)) {
                            fetchingOpacity = 1.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                animationDone = true
                        }
                    }

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .opacity(fetchingOpacity)
                    .scaleEffect(1.5)
            }

            if let errorMessage = error?.message {
                Text(errorMessage)
                    .font(.headline)
                    .foregroundColor(.red)
                    .transition(.opacity)
            }
        }
    }
}


//
//#Preview {
//    IntroView(animationDone: .constant(false))
//}
