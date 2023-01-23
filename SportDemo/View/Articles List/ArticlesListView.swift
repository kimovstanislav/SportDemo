//
//  ContentView.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 20.01.23.
//

import SwiftUI

struct ArticlesListView: View {
    @ObservedObject var viewModel:  ArticlesListViewModel
    
    var body: some View {
        NavigationView {
            switch viewModel.viewState {
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
    }
    
    
    // MARK: - Loading
    
    private func loaderView() -> some View {
        ProgressView()
    }
    
    
    // MARK: - Empty list
    
    private func emptyListView() -> some View {
        Text("No articles")
    }
    
    
    // MARK: - Articles list
    
    private func articlesListView(articles: [Article]) -> some View {
        List(articles.indices, id: \.self) { index in
            // TODO: make an actual detail screen
//            NavigationLink(destination: ArticleDetailView(viewModel: ArticleDetailViewModel(article: articles[index]))) {
                articleCell(article: articles[index])
//            }
            .accessibility(identifier: String(format: AccessibilityIdentifiers.ArticlesList.listCellFormat, index))
        }
        .listStyle(PlainListStyle())
        .navigationTitle("News")
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
        ArticlesListView(viewModel: ViewModelFactory.shared.makeArticlesListViewModel())
    }
}
