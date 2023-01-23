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
    }
    
    func loadArticlesList() async throws -> ArticleListResponse {
        let jsonString = JsonHelper.readJsonString(named: MockJsonFiles.articlesList)
        let data = jsonString.data(using: .utf8)!
        return try decodeArtlicesListResponse(data: data)
    }
}
