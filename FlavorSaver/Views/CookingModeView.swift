//
//  CookingModeView.swift
//  FlavorSaver
//
//  Created by Jennifer Zhang on 11/2/23.
//

import SwiftUI

struct CookingModeView: View {
    @State var recipe : Recipe
    var body: some View {
        TabView {
                ForEach(recipe.getRecipeSteps(), id: \.0){ step, ingredients in
                    VStack{
                        HStack{
                            Text(step)
                                .font(.title)
                            Spacer()
                        }
                        HStack{
                            VStack{
                                ForEach(ingredients, id: \.self){ ingredient in
                                    HStack{
                                        Button(action: {}, label: {
                                            Text(ingredient)
                                        })
                                        .disabled(true)
                                        .buttonStyle(.bordered)
                                        .foregroundStyle(Color.black)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
            }
        }
        .tabViewStyle(.page)
    }
}

struct CookingModeIntro: View {
    var body: some View {
        
        VStack (spacing: 128){
            VStack (spacing: 64){
                HStack {
                    Text("Cooking Mode")
                        .font(.headline)
                    Spacer()
                }
                Text("Welcome to Cooking Mode!")
                    .font(.title)
                    .foregroundStyle(Color.gray)
            }
            HStack{
                Spacer()
                VStack (alignment: .trailing) {
                    HStack {
                        Text("To go to the next step")
                            .font(.body)
                        Image(systemName: "chevron.right")
                    }
                    Text("Swipe left")
                        .font(.title)
                }
            }
            
            HStack {
                VStack (alignment: .leading) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("To go to the previous step")
                            .font(.body)
                    }
                    Text("Swipe right")
                        .font(.title)
                }
                Spacer()
            }
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}
