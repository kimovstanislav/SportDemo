//
//  ArticlesListViewModel.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 22.01.23.
//

import Foundation

class ArticlesListViewModel: ObservableObject {
    init() {
        // TODO: this is just testing. To make proper loading later.
        Task {
            do {
                let apiClient = APIClient()
                let result = try await apiClient.loadArticlesList()
                print("\n\n\n\n\n=> sections count: \(result.sections.count)\n\n\n\n\nresult: \(result)")
            }
            catch let error as SDError  {
                print("> error: \(error)")
            }
        }
        
    }
}
