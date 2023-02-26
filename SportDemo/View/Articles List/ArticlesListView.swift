//
//  ContentView.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 20.01.23.
//

import SwiftUI

// Until now I had UIKit as a base in a project with a Coordinator using a UINavigationController. With a mix of UIKit ViewControllers and SwiftUI Views wrapped in a hosting controller.
// Here, perfectly I'd want to use the new NavigationStack and also a Coordinator pattern for app-wide programmatic navigation. But NavigationStack is new to me and I'd need some research first. Not in the scope of this small demo task.
struct ArticlesListView: View {
    @ObservedObject var viewModel:  ArticlesListViewModel
    
    @State private var showFilterCategorySheet = false
    
    var body: some View {
        NavigationView {
            switch viewModel.viewState {
            case .none:
                EmptyView()
                
            case .loading:
                loaderView()
                
            case .showEmptyList:
                emptyListView()

            case .showArticles(let articles):
                articlesListView(articles: articles)

            case .showError(let errorMessage):
                errorView(errorMessage: errorMessage)
            }
        }
        .alert(isPresented: $viewModel.alertModel.showAlert, content: { () -> Alert in
            Alert(title: Text(viewModel.alertModel.title), message: Text(viewModel.alertModel.message), dismissButton: .default(Text(SDStrings.Button.close)))
        })
        .sheet(isPresented: $showFilterCategorySheet) {
            SelectArticleCategoryView(
                categories: viewModel.allCategories,
                selectedCategory: { (selectedCategory: Article.Category?) -> () in
                    viewModel.doFilterArticlesByCategory(selectedCategory)
            })
       }
    }
    
    
    // MARK: - Loading
    
    private func loaderView() -> some View {
        ProgressView()
    }
    
    
    // MARK: - Empty list
    
    private func emptyListView() -> some View {
        Text(SDStrings.Screen.ArticlesList.noArticles)
    }
    
    
    // MARK: - Articles list
    
    private func articlesListView(articles: [Article]) -> some View {
        // Need index for accesibility ids for UI tests.
        List(articles.indices, id: \.self) { index in
            NavigationLink(destination: ArticleDetailView(url: URL(string: articles[index].url)!)) {
                articleCell(article: articles[index])
            }
            .accessibility(identifier: String(format: AccessibilityIdentifiers.ArticlesList.listCellFormat, index))
        }
        .listStyle(PlainListStyle())
        .navigationTitle(SDStrings.Screen.ArticlesList.title)
        .toolbar {
            Button(SDStrings.Button.filter) {
                showFilterCategorySheet = true
            }
        }
        .accessibility(identifier: AccessibilityIdentifiers.ArticlesList.list)
    }
    
    private func articleCell(article: Article) -> some View {
        HStack() {
            AsyncImage(url: URL(string: article.image.small)) { image in
                   image
                       .resizable()
                       .aspectRatio(contentMode: .fit)
               } placeholder: {
                   Image(systemName: "photo")
                       .imageScale(.large)
                       .foregroundColor(.gray)
               }
               .frame(width: 120, height: 80, alignment: .center)

            VStack(alignment: .trailing, spacing: 4) {
                Text(article.title)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)
                Text(article.text)
                    .font(.system(size: 12, weight: .regular))
                    .lineLimit(2)
                Text(article.category.title)
                    .font(.system(size: 10, weight: .regular))
                Text(article.displayDate)
                    .font(.system(size: 10, weight: .regular))
            }
            .padding(.leading, 8)
        }
    }
    
    
    // MARK: - Error
    
    private func errorView(errorMessage: String) -> some View {
        VStack(alignment: .center) {
            Spacer()
            Text(errorMessage)
                .font(.headline.bold())
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesListView(viewModel: ViewModelFactory.shared.makeDummyArticlesListViewModel())
    }
}
