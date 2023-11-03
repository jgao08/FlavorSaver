//
//  RecipeView.swift
//  FlavorSaver
//
//  Created by Jennifer Zhang on 11/2/23.
//

import SwiftUI

struct RecipeView: View {
  @State private var cookingMode = false
  let recipeSteps =
  """
  1. Melt 1/4 cup of the butter. Pour 2 tablespoons of the melted butter into an 8-cup bundt pan; brush the butter over pan sides and bottom. Mix together the brown sugar, cinnamon, nutmeg, and almonds. Sprinkle bottom of pan with half the brown sugar mixture; combine the remaining mixture with the remaining melted butter; set aside.
  
  2. In a large bowl, beat remaining 1/4 cup butter with granulated sugar until blended. Beat in eggs, 1 at a time, until blended. Beat in orange peel and banana.
  
  3. Mix all-purpose and whole-wheat flours, baking powder, soda, and salt. Add to banana mixture along with the buttermilk; stir until well blended.
  
  4. Pour half the batter into prepared pan. Spoon remaining brown sugar mixture evenly over top; cover with remaining batter.
  
  5. Bake in a 350° oven until a long wood skewer inserted into the thickest part of the cake comes out clean, about 50 minutes. Cool the cake on a rack about 5 minutes, then invert cake onto a serving plate. Serve the cake warm or cool.
  """
  let recipeIngredients = ["1 potato", "1 orange", "2 jellybeans", "1 pizza", "2L Mist Twist"]
  let recipeDescription = "A bag of ripe bananas inspired Jan McHargue to create this coffee cake. You can enjoy the banana cake with its spicy brown sugar-almond topping and filling for brunch, with coffee, or for dessert."
  let tags = ["1 hour", "dessert", "brunch"]
  let authorName = "Your Mom"

  
  var body: some View {
    ScrollView{
      VStack{
        ZStack{
          Image("testimg2")
            .resizable()
            .frame(height: UIScreen.main.bounds.height / (3/2))
          
          VStack{
            Spacer()
            HStack{
              Text("Recipe Title")
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundStyle(Color.white)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
              Spacer()
            }
            .padding(.horizontal)
            
            
            HStack{
              Button(action: {
                cookingMode.toggle()
              }, label: {
                Image(systemName: "play.fill")
                Text("Cooking Mode")
              })
              .tint(.white)
              .controlSize(.large)
              .buttonStyle(.borderedProminent)
              .foregroundStyle(Color.black)
              .shadow(radius: 10)
              .sheet(isPresented: $cookingMode, content: {
                CookingModeView()
              })
              Spacer()
            }
            .padding()
          }
        }
        
        VStack{
          Text(recipeDescription)
            .padding()
          
          
          HStack{
            ForEach(tags, id: \.self) {tag in
              Button(action: {}, label: {
                Text(tag)
              })
              .buttonStyle(.bordered)
            }
            Spacer()
          }
          .padding(.horizontal)
          
          
          HStack{
            Text("by " + authorName)
              .font(.caption)
            Spacer()
          }
          .padding()
        }
        .padding(.vertical)
        
        
        HStack{
          Text("Ingredients")
            .font(.headline)
          Spacer()
        }
        .padding(.horizontal)
        
        
        VStack{
          ForEach(recipeIngredients, id: \.self){ ing in
            HStack{
              Text("• " + ing)
              Spacer()
            }
          }
        }
        .padding()
        
        
        HStack{
          Text("Steps")
            .font(.headline)
          Spacer()
        }
        .padding(.horizontal)
        
          
        HStack{
          Text(recipeSteps)
          Spacer()
        }
        .padding()
      }
    }
    .edgesIgnoringSafeArea(.top)
  }
}



#Preview {
    RecipeView()
}
