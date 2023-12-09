//
//  ViewModifiers.swift
//  FlavorSaver
//
//  Created by Erica Fu on 12/9/23.
//

import Foundation
import SwiftUI

//Text styles
//struct LargeTitle: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .font(Font.custom("Quicksand-Bold", size: 28))
//            .textCase(.uppercase)
//    }
//}

//Button styles
//struct DefaultButton: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .modifier(ButtonText())
//            .padding(.vertical, 12)
//            .padding(.horizontal, 30)
//            .foregroundColor(Color("Black"))
//            .background(Color("White"))
//            .cornerRadius(10)
//            .shadow(color: Color("Black"), radius: 0, x: 0, y: 4)
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color("Black"), lineWidth: 1)
//            )
//    }
//}

//Tags
struct Tag: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.body)  // later change to viewmodifer version
                .padding(8)
                .foregroundColor(.white)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(4)

    }
}

struct TextShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .black, radius: 8)

    }
}


