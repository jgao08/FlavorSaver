//
//  ViewModifiers.swift
//  FlavorSaver
//
//  Created by Erica Fu on 12/9/23.
//

import Foundation
import SwiftUI

struct Tag: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
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


