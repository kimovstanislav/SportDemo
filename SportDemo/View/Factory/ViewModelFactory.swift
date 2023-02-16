//
//  ViewModelFactory.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 23.01.23.
//

import Foundation

class ViewModelFactory {
    // Could create in App and pass through EnvironmentVariable, but prefer to avoid SwiftUI specific approach.
    static let shared = ViewModelFactory()
    
    private let apiClient: SDAPI = APIClient()
    
    func makeArticlesListViewModel() -> ArticlesListViewModel {
        return ArticlesListViewModel(stateMachine: ArticlesListViewModel.StateMachine(state: .start), apiClient: apiClient)
    }
}
