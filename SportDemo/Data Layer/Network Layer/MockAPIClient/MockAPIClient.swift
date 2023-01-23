//
//  MockAPIClient.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 22.01.23.
//

import Foundation

class MockAPIClient: SDAPI {
    enum MockJsonFiles {
        static let articlesList = "articles_list"
        static let test = "test"
    }
    
    func loadArticlesList() async throws -> ArticleCategoriesList {
        return try getObject(fileName: MockJsonFiles.articlesList)
    }
    
    func loadTest() async throws -> TestCategoriesList {
        return try getObject(fileName: MockJsonFiles.test)
    }
}

extension MockAPIClient {
    func getObject<T: Decodable>(fileName: String) throws -> T {
        let jsonString = JsonHelper.readJsonString(named: fileName)
        let data = jsonString.data(using: .utf8)!
        return try decodeApiResponse(data: data)
    }
}