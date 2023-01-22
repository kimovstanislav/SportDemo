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
                let test = try await mockApiClient.loadTest()
                print("=> test: \(test)")
            }
            catch let error as SDError  {
                print("> error: \(error)")
            }
        }
        
    }
}
