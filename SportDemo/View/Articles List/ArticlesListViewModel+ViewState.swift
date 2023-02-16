//
//  ArticlesListViewModel+ViewState.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 16.02.23.
//

import Foundation

extension ArticlesListViewModel {
    enum ViewState {
        case loading
        case showEmptyList
        case showArticles(articles: [Article])
        // We don't use an error state actually, should be enough to display an alert and then a local/empty list.
        case showError(errorMessage: String)
    }
}
