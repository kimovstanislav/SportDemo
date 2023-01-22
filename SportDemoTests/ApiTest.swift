//
//  ApiTest.swift
//  SportDemoTests
//
//  Created by Stanislav Kimov on 22.01.23.
//

import XCTest
@testable import SportDemo

final class ApiTest: XCTestCase {
    var mockApiClient: SDAPI = MockAPIClient()

    func testDecodeData() throws {
        Task {
            do {
                /*let articles = try await mockApiClient.loadArticlesList()
                print("articles: \(articles)")
                guard let articleCategories = articles.articleCategories else {
                    XCTFail("No articles loaded.")
                    return
                }
                XCTAssert(articleCategories.count == 2)*/
                let test = try await mockApiClient.loadTest()
                print("=> test: \(test)")
                XCTAssert(test.testCategories.count == 2)
            }
            catch let error as SDError  {
//                Task.detached { @MainActor in
                await MainActor.run {
                    XCTFail(error.message)
                }
            }
        }
    }
}
