//
//  ArticlesListViewModel.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 22.01.23.
//

import Foundation

class ArticlesListViewModel: BaseViewModel {
    let apiClient: SDAPI
    
    @Published var viewState: ViewState = .loading
    
    init(apiClient: SDAPI) {
        self.apiClient = apiClient
        super.init()
        handleEvent(.onAppear)
    }
    
    private func updateArticlesList(_ articles: [Article]) {
        if articles.isEmpty {
            setViewState(.showEmptyList)
        }
        else {
            setViewState(.showArticles(articles: articles))
        }
    }
    
    private func showLoading() {
        setViewState(.loading)
    }
    
    private func setViewState(_ state: ViewState) {
        DispatchQueue.main.async {
            self.viewState = state
        }
    }
}


// MARK: - Load from server

extension ArticlesListViewModel {
    private func loadArticlesFromServer() {
        Task { [weak self] in
            do {
                let response = try await apiClient.loadArticlesList()
                self?.handleEvent(.onApiArticlesLoaded(response.sections))
            }
            catch let error as SDError  {
                self?.handleEvent(.onFailedToLoadApiArticles(error))
            }
        }
    }
}


// MARK: - Handle API response

extension ArticlesListViewModel {
    private func handleGetApiArticlesSuccess(_ sections: [ArticleListSection]) {
        let articles = allArticlesFromSections(sections)
        let sortedArticles = articles.sorted { article1, article2 in
            guard let date1 = article1.date else { return false }
            guard let date2 = article2.date else { return true }
            return date1 > date2
        }
        updateArticlesList(sortedArticles)
    }
    
    private func handleGetApiArticlesFailure(_ error: SDError) {
        if viewState == .loading {
            setViewState(.showError(errorMessage: SDStrings.Error.API.loadingArticlesFromServerErrorMessage))
        }
        // And display an alert for the API error.
        self.processError(error)
    }
    
    private func allArticlesFromSections(_ sections: [ArticleListSection]) -> [Article] {
        let articles = sections.compactMap { section in
            switch section.data {
            case .articlesCategory(_, let articles):
                return articles
            default:
                return nil
            }
        }
        return articles.flatMap { $0 }
    }
        
}


// MARK: - States + Events

extension ArticlesListViewModel {
    enum ViewState {
        case loading
        case showEmptyList
        case showArticles(articles: [Article])
        // We don't use an error state actually, should be enough to display an alert and then a local/empty list.
        case showError(errorMessage: String)
    }
    
    // TODO: to add filter by category
    enum Event {
        /// UI lifecycle
        case onAppear
        
        /// Load API
        case onApiArticlesLoaded([ArticleListSection])
        case onFailedToLoadApiArticles(SDError)
    }
    
    func handleEvent(_ event: Event) {
        switch event {
            /// UI lifecycle
        case .onAppear:
            loadArticlesFromServer()
            
            /// Load API
        case let .onApiArticlesLoaded(articles):
            handleGetApiArticlesSuccess(articles)
            
        case let .onFailedToLoadApiArticles(error):
            handleGetApiArticlesFailure(error)
        }
    }
}


extension ArticlesListViewModel.ViewState: Equatable {
    static func ==(lhs: ArticlesListViewModel.ViewState, rhs: ArticlesListViewModel.ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
            
        case (.showEmptyList, .showEmptyList):
            return true
            
        case (let .showArticles(articles1), let .showArticles(articles2)):
            return articles1.sorted { a, b in a.id < b.id } == articles2.sorted { a, b in a.id < b.id }
            
        case (let .showError(error1), let .showError(error2)):
            return error1 == error2

        default:
            return false
        }
    }
}
