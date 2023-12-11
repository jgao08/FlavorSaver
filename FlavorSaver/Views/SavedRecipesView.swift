//
//  SavedRecipes.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/30/23.
//

import Foundation
import SwiftUI

struct SavedRecipesView: View {
    @EnvironmentObject var user: User
        
    private let columns = [
        //        GridItem(.flexible(), spacing: 16),
        //        GridItem(.flexible(), spacing: 16)
        GridItem(.adaptive(minimum: 170))
    ]
    
    var body: some View  {
      NavigationStack{
        ScrollView {
          VStack (spacing: 32) {
            //                HStack {
            //                    Text("My Folders")
            //                        .font(.headline)
            //                    Spacer()
            //                    AddFolderButton(recipe: nil, folders: $folders)
            //                }
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(user.getSavedRecipeFolders(), id: \.self) { folder in
                FolderCard(folder: folder).environmentObject(user)
              }
            }
          }
        }
        .padding(.horizontal)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
          print("updating folders from savedRecipesView")
        }
        .navigationTitle("My Folders")
        .navigationBarItems(trailing: AddFolderButton(recipe: nil))
      }
    }
}

struct FolderCard: View {
    @EnvironmentObject var user: User
    @State var folder: Folder
    @State var isShowingFolder: Bool = false
    
    var body: some View {
      NavigationLink(destination: FolderView(folder: folder, isShowingFolder: $isShowingFolder).environmentObject(user)) {
            
            VStack (alignment: .leading) {
                if user.getSavedRecipes(folderName: folder.name).count > 0 {
                    AsyncImage(url: URL(string: user.getSavedRecipes(folderName: folder.name).first!.image)) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(.gray)
                                .frame(width: 170, height: 170)
                                .modifier(RoundedEdge(width: 2, color: .black, cornerRadius: 10))
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 170, height: 170)
                                .clipped()
                        case .failure:
                            Rectangle()
                                .fill(.gray)
                                .frame(width: 170, height: 170)
                        @unknown default:
                            // Since the AsyncImagePhase enum isn't frozen,
                            // we need to add this currently unused fallback
                            // to handle any new cases that might be added
                            // in the future:
                            EmptyView()
                        }
                    }
                    .frame(width: 170, height: 170)
                    .cornerRadius(10)
                    
                } else {
                    Rectangle()
                        .fill(.gray)
                        .frame(width: 170, height: 170)
                        .cornerRadius(10)
                    
                }
                Text(folder.name)
                    .font(.body)
                    .foregroundColor(.black)
                Text("\(user.getSavedRecipes(folderName: folder.name).count) Recipes")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct RoundedEdge: ViewModifier {
    let width: CGFloat
    let color: Color
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content.cornerRadius(cornerRadius - width)
            .padding(width)
            .background(color)
            .cornerRadius(cornerRadius)
    }
}

