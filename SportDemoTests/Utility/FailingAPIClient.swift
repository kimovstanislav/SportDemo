//
//  FailingAPIClient.swift
//  SportDemoTests
//
//  Created by Stanislav Kimov on 24.01.23.
//

import Foundation
@testable import SportDemo

class FailingAPIClient: SDAPI {
    // Can set any error we like
    var failingError: SDError = SDError.Factory.makeDecodingError(cause: nil)
    
    func loadArticlesList() async throws -> ArticleListResponse {
        throw failingError
    }
}
