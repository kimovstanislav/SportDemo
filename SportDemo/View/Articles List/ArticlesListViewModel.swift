//
//  ArticlesListViewModel.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 22.01.23.
//

import Foundation
import Combine

class ArticlesListViewModel: BaseViewModel {
    let apiClient: SDAPI
    
    private let stateMachine: StateMachine
    var state: StateMachine.State {
        willSet { leaveState(state) }
        didSet { enterState(state) }
    }
    private var stateCancellable: AnyCancellable?
    
    @Published var viewState: ViewState = .loading
    
    var allArticles: [Article] = []
    var filteredArticles: [Article] = []
    
    // We store categories, not to recalculate this array every time it's requested.
    var allCategories: [Article.Category] = [Article.Category]()
    // Filter category is stored to be used when reloading articles or going back to filter screen.
    var filterCategory: Article.Category? = nil
    
    var error: SDError? = nil
    
    init(stateMachine: StateMachine, apiClient: SDAPI) {
        self.apiClient = apiClient
        self.stateMachine = stateMachine
        self.state = stateMachine.state
        super.init()
        
        self.stateCancellable = stateMachine.statePublisher.sink { state in
            self.state = state
        }
        stateMachine.tryEvent(.loadArticles)
    }
    

    private func setViewState(_ state: ViewState) {
        DispatchQueue.main.async {
            self.viewState = state
        }
    }
}


// MARK: - Actions

extension ArticlesListViewModel {
    func doFilterArticlesByCategory(_ category: Article.Category?) {
        filterArticlesForCategory(category)
        showArticlesList(filteredArticles)
    }
}


// MARK: - View update

extension ArticlesListViewModel {
    private func showLoading() {
        setViewState(.loading)
    }
    
    private func showArticlesList(_ articles: [Article]) {
        if articles.isEmpty {
            setViewState(.showEmptyList)
        }
        else {
            setViewState(.showArticles(articles: articles))
        }
    }
    
    private func showError(_ error: String) {
        setViewState(.showError(errorMessage: error))
    }
}


// MARK: - Load from server

extension ArticlesListViewModel {
    private func loadArticlesFromServer() {
        Task { [weak self] in
            do {
                let response = try await apiClient.loadArticlesList()
                self?.handleGetApiArticlesSuccess(response)
            }
            catch let error as SDError  {
                self?.handleGetApiArticlesFailure(error)
            }
        }
    }
}


// MARK: - Handle API response

extension ArticlesListViewModel {
    private func handleGetApiArticlesSuccess(_ result: ArticleListResponse) {
        let loadedArticles = result.getAllAricles()
        let sortedArticles = loadedArticles.sorted { article1, article2 in
            guard let date1 = article1.date else { return false }
            guard let date2 = article2.date else { return true }
            return date1 > date2
        }
        allArticles = sortedArticles
        allCategories = getAllCategories()
        filterArticlesForCategory(nil)
        stateMachine.tryEvent(.loadArticlesSuccess)
    }
    
    private func handleGetApiArticlesFailure(_ error: SDError) {
        self.error = error
        stateMachine.tryEvent(.loadArticlesFailure)
    }
    
    
    private func getAllCategories() -> [Article.Category] {
        allArticles.map { $0.category }.unique
    }
        
    
    // MARK: - Filter articles
    
    private func filterArticlesForCategory(_ category: Article.Category?) {
        filterCategory = category
        filteredArticles = getFilteredArticles()
    }
    
    private func getFilteredArticles() -> [Article] {
        guard let filter = filterCategory else { return allArticles }
        // Filtering by id, not filterId. Don't completely understand the Category logic, but I see different sports can be under the same filterId and filterTitle. For simplicity don't go deeper into it.
        return allArticles.filter { $0.category.id == filter.id }
    }
}


// MARK: - State changes

extension ArticlesListViewModel {
    func leaveState(_ state: StateMachine.State) {
        switch state {
        case .start:
            break
        case .loadingArticles:
            break
        case .showArticles:
            allArticles = []
            filteredArticles = []
            break
        case .error:
            error = nil
            break
        }
    }
    
    func enterState(_ state: StateMachine.State) {
        switch state {
        case .start:
            break
        case .loadingArticles:
            showLoading()
            loadArticlesFromServer()
            break
        case .showArticles:
            showArticlesList(filteredArticles)
            break
        case .error:
            showError(SDStrings.Error.API.loadingArticlesFromServerErrorMessage)
            // Log and display an alert for the API error.
            if let error = error {
                self.processError(error)
            }
            break
        }
    }
}
