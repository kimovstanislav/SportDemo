//
//  ViewModelFactory+Dummy.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 24.01.23.
//

import Foundation

extension ViewModelFactory {
    func makeDummyArticlesListViewModel() -> ArticlesListViewModel {
        return ArticlesListViewModel(stateMachine: ArticlesListViewModel.StateMachine(state: .start), apiClient: MockAPIClient())
    }
}
