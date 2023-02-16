//
//  SelectArticleCategoryView.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 24.01.23.
//

import SwiftUI
import Combine

// Currently this view functionality is basic, no logic here, pure UI, no need for a ViewModel.
struct SelectArticleCategoryView : View {
    @Environment(\.dismiss) var dismiss
    let categories: [Article.Category]
    // Using a closure for a callback here to make it fast and simple.
//    var selectedCategory: ((_ category: Article.Category?) -> ())
    // Instead of a closure, use Combine
    let selectedCategory = PassthroughSubject<Article.Category?, Never>()
    
//    init(categories: [Article.Category], selectedCategory: @escaping ((_ category: Article.Category?) -> ())) {
    init(categories: [Article.Category]) {
        self.categories = categories
//        self.selectedCategory = selectedCategory
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(SDStrings.Button.close) {
                    dismiss()
                }
            }
            .padding()
            // A quick and lazy way to handle the case of no category. Not a proper UI for a real app.
            // A more proper way would be to add "All" cell as a first. Or even multiple selection. But takes extra effort.
            Button(SDStrings.Screen.ArticlesCategoryFilter.noFilter) {
//                selectedCategory(nil)
                selectedCategory.send(nil)
                dismiss()
            }
            List(categories) { category in
                Button(action: {
//                    selectedCategory(category)
                    selectedCategory.send(category)
                    dismiss()
                }) {
                    Text(category.title)
                }
            }
        }

    }
}
