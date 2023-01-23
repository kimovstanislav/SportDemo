//
//  SDAPI.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 22.01.23.
//

import Foundation

protocol SDAPI {
    /// Throws VSError
    func loadArticlesList() async throws -> ArticleListResponse
    
    /// TESTING
//    func loadTest() async throws -> TestCategoriesList
}

// General parsing
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

// TODO: see if we want to improve for a dynamic parsing approach later, or remove it.
// Special parcing (with more work could be somehow split up and generalized)
extension SDAPI {
    private func processJson(json: [String: Any]) throws -> ArticleListResponse {
        if let dataJson: [String: Any] = json["data"] as? [String: Any] {
            var categories = [ArticleListCategory]()
            try dataJson.forEach { (key: String, value: Any) in
                // Value is either array (activity) of dictionary (add)
                if let array = value as? [Any] {
                    let result: ArticleListCategory = try processJsonArray(name: key, array: array)
                    categories.append(result)
                }
                else if let dictionary = value as? [String: Any] {
                    let result: ArticleListCategory = try processJsonDictionary(name: key, dictionary: dictionary)
                    categories.append(result)
                }
            }
            
            return ArticleListResponse(categories: categories)
        }
        else {
            throw SDError.Factory.makeDecodingError(cause: nil)
        }
    }
    
    private func processJsonArray(name: String, array: [Any]) throws -> ArticleListCategory {
        let articles = try array.map { arrayEntry in
            if let dictionary = arrayEntry as? [String: Any] {
                let dictionaryJsonData = try JSONSerialization.data(
                    withJSONObject: dictionary,
                    options: [])
                
                let result: Article = try decodeApiResponse(data: dictionaryJsonData)
                return result
            }
            else {
                throw SDError.Factory.makeDecodingError(cause: nil)
            }
        }
        return ArticleListCategory(name: name, articles: articles)
    }
    
    private func processJsonDictionary(name: String, dictionary: [String: Any]) throws -> ArticleListCategory {
        // TODO: parse for add if we want
        return ArticleListCategory(name: "", articles: [Article]())
    }
    
    func decodeArtlicesListResponse(data: Data) throws -> ArticleListResponse {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
               return try processJson(json: json)
            }
            else {
                throw SDError.Factory.makeDecodingError(cause: nil)
            }
        } catch let error {
            throw SDError.Factory.makeDecodingError(cause: error)
        }
    }
}
