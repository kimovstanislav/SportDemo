//
//  ArticlesListViewModel.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 22.01.23.
//

import Foundation

class ArticlesListViewModel: ObservableObject {
    init() {
        print(">>>!!!!! HALLO!!!!!<<<<<")
        Task {
            do {
                let mockApiClient = MockAPIClient()
                let result = try await mockApiClient.loadArticlesList()
                print("\n\n\n\n\n=> sections count: \(result.sections.count)\n\n\n\n\nresult: \(result)")
            }
            catch let error as SDError  {
                print("> error: \(error)")
            }
        }
        
    }
}
