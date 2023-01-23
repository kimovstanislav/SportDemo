//
//  SDAPI+ArticlesList.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 23.01.23.
//

import Foundation

// Need special parcing for a dynamic json response for ArticleList.
// TODO: make a separate json decoder class for that? Or even use a Strategy pattern? Or fine to just have a separate extension file for that? In any case for a current small project it's enough, and it's not hard to change if need to scale in theoretical future.
extension SDAPI {
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
    
    // It's fine to have generic names for these functions, as they are private, and only visible in this scope.
    private func processJson(json: [String: Any]) throws -> ArticleListResponse {
        if let dataJson: [String: Any] = json["data"] as? [String: Any] {
            var categories = [ArticleListSection]()
            try dataJson.forEach { (key: String, value: Any) in
                // Value is either array (activity) of dictionary (add)
                if let array = value as? [Any] {
                    let result: ArticleListSection = try processJsonArray(name: key, array: array)
                    categories.append(result)
                }
                else if let dictionary = value as? [String: Any] {
                    let result: ArticleListSection = try processJsonDictionary(name: key, dictionary: dictionary)
                    categories.append(result)
                }
            }
            return ArticleListResponse(sections: categories)
        }
        else {
            throw SDError.Factory.makeDecodingError(cause: nil)
        }
    }
    
    private func processJsonArray(name: String, array: [Any]) throws -> ArticleListSection {
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
        return ArticleListSection(data: .articlesCategory(name, articles))
    }
    
    private func processJsonDictionary(name: String, dictionary: [String: Any]) throws -> ArticleListSection {
        // TODO: parse for add if we want
        return ArticleListSection(data: .add(Add()))
    }
}
