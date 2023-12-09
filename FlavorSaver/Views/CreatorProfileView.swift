//
//  CreatorProfileView.swift
//  FlavorSaver
//
//  Created by Jennifer Zhang on 12/9/23.
//

import SwiftUI

struct CreatorProfileView: View {
    var body: some View {
      ScrollView{
        HStack{
          Image("rat")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .clipShape(Circle())
          VStack{
            Text("Foodista")
              .font(.title)
            Text("Bio: lorem ipsum")
          }
        }
        Divider()
        
      }
    }
}

//#Preview {
//    CreatorProfileView()
//}
