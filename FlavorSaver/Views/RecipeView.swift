//
//  RecipeView.swift
//  FlavorSaver
//
//  Created by Jennifer Zhang on 11/2/23.
//

import SwiftUI
//import SwiftUITrackableScrollView

struct RecipeView: View {
  let sectionSpacing: CGFloat = 32
  let paraSpacing: CGFloat = 16
  @State private var cookingMode = false
  @State var recipe : Recipe
  
  var body: some View {
    ScrollView{
      VStack{
        ZStack{
          AsyncImage(url: URL(string: recipe.image))
//            .resizable()
            .frame(height: UIScreen.main.bounds.height / (3/2))
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
          
          VStack(spacing: paraSpacing){
            Spacer()
            HStack{
              Text(recipe.name)
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
            .padding(.horizontal)
          }
          .padding(.bottom, sectionSpacing)
        }
        
        
        VStack(spacing: sectionSpacing){
          VStack(spacing: paraSpacing){
            Text(recipe.summary.replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression)
)
            
            ScrollView(.horizontal){
              HStack{
                ForEach(recipe.dishTypes, id: \.self) {tag in
                  Button(action: {}, label: {
                    Text(tag)
                  })
                  .buttonStyle(.bordered)
                  .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                  .foregroundStyle(Color.black)
                }
                Spacer()
              }
            }
            
            
            HStack{
              Text("by " + recipe.author)
                .font(.caption)
              Spacer()
            }
          }
          
          VStack(spacing: paraSpacing){
            HStack{
              Text("Ingredients")
                .font(.headline)
              Spacer()
            }
            
            
            VStack{
              ForEach(recipe.getIngredientsWithAmounts(), id: \.self){ ing in
                HStack{
                  Text("• " + ing)
                  Spacer()
                }
              }
            }
          }
          
          
          VStack(spacing: paraSpacing){
            HStack{
              Text("Steps")
                .font(.headline)
              Spacer()
            }
            
            
            VStack{
              ForEach(recipe.getRecipeSteps().indices, id: \.self){ index in
                let step = recipe.getRecipeSteps()[index]
                let stepInstruction = step.0

                VStack{
                  HStack{
                    Text("\(index + 1). \(stepInstruction)")
                    Spacer()
                  }
                }
                .padding(.vertical, 4)
              }
              Spacer()
            }
          }
        }
        .padding(.bottom, sectionSpacing)
        .padding(.top, paraSpacing)
        .padding(.horizontal, paraSpacing)
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle(recipe.name)
    .toolbar(content: {
      SaveIcon()
    })
//    .navigationBarItems(leading: Spacer(minLength: 500))
//    .navigationBarTitleDisplayMode(.inline)
    .edgesIgnoringSafeArea(.all)
  }
  
}



//#Preview {
//  RecipeView(recipe: )
//}
