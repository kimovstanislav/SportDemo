//
//  SDAPI.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 22.01.23.
//

import Foundation

protocol SDAPI {
    /// Throws VSError
    func loadArticlesList() async throws -> ArticleCategoriesList
    
    /// TESTING
    func loadTest() async throws -> TestCategoriesList
}

extension SDAPI {
    func decodeApiResponse<T: Decodable>(data: Data) throws -> T {
        do {
            let object: T = try JSONDecoder().decode(T.self, from: data)
            return object
        }
        catch let error {
            let sdError: SDError = SDError.Factory.makeDecodingError(cause: error)
            throw sdError
        }
    }
}
