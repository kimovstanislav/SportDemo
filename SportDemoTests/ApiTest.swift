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
                let result = try await mockApiClient.loadArticlesList()
                XCTAssert(result.sections.count == 6)
            }
            catch let error as SDError  {
                Task.detached { @MainActor in
                    XCTFail(error.message)
                }
            }
        }
    }
}
