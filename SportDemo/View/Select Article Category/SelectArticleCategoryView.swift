//
//  SelectArticleCategoryView.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 24.01.23.
//

import SwiftUI

// This view functionality is basic, no ned for a view model.
struct SelectArticleCategoryView : View {
//    let categories: [Article.Category]
    
    // TODO: add a callback on selected
    // TODO: try to do it better maybe with Combine, or SwiftUI16 selected (if would work)
    
//    init(categories: [Article.Category]) {
//        self.categories = categories
//    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
           Button {
              dismiss()
           } label: {
               Image(systemName: "xmark.circle")
                 .font(.largeTitle)
                 .foregroundColor(.gray)
           }
         }
         .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
         .padding()
    }
    
    // TODO: make close button to close modal view
    /*var body: some View {
        List(categories.indices, id: \.self) { index in
            Button(action: {
                // TODO: dismiss modal view
            }) {
                Text(categories[index].title)
            }
        }
    }*/
}
