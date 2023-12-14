//
//  CreatorProfileView.swift
//  FlavorSaver
//
//  Created by Jennifer Zhang on 12/9/23.
//

import SwiftUI

struct CreatorProfileView: View {
  @StateObject var user: User = User(userID: "oWkYfZMRPYYMC3hIAb5pW8jeg1a2")
    
  private let columns = [
      GridItem(.adaptive(minimum: 170))
  ]
  
    var body: some View {
      ScrollView{
        HStack{
          Image("guy")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .clipShape(Circle())
          VStack{
            HStack{
              Text("Guy Fieri")
                .font(.title)
              Spacer()
            }
            HStack{
              Text("American restaurateur, author, and an Emmy Award winning television presenter. He co-owned three now defunct restaurants in California, licenses his name to restaurants in cities all over the world, and is known for hosting various television series on the Food Network. ")
//              bio copied from wikipedia
              Spacer()
            }
          }
          Spacer()
        }
        Divider()
        HStack{
          Text("Recipes")
            .font(.title)
        }
        ScrollView {
            VStack (spacing: 32) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(user.getSavedRecipeFolders(), id: \.self) { folder in
                        FolderCard(folder: folder).environmentObject(user)
                    }
                }
            }
        }
        .onAppear{
          print(user.getUsername())
        }
      }
    }
}


