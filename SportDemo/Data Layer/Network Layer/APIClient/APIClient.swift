//
//  APIClient.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 23.01.23.
//

import Foundation

class APIClient: SDAPI {
    let session = URLSession.shared
    enum URLs {
        static let host = "https://www.laola1.at"
        static let environment = "/templates/generated"
        static let apiVersion = "/1"
        
        enum Endpoints {
            static let articlesList = "/json/mobile/overview.json"
        }
    }
    
    private func makeUrl(host: String, environment: String, apiVersion: String, endpoint: String) -> URL {
        let urlString = "\(host)\(environment)\(apiVersion)\(endpoint)"
        guard let url = URL(string: urlString) else {
            unexpectedCodePath(message: "Invalid URL.")
        }
        return url
    }
    
    func loadArticlesList() async throws -> ArticleListResponse {
        let url = makeUrl(host: URLs.host, environment: URLs.environment, apiVersion: URLs.apiVersion, endpoint: URLs.Endpoints.articlesList)
        return try await performLoadArticleListRequest(url: url)
    }
}

extension APIClient {
    private func getDataFromApi(url: URL) async throws -> Data {
        do {
            let (data, _) = try await session.data(from: url)
            return data
        }
        catch let error {
            let vsError = APIClient.ErrorMapper.convertToSDError(error)
            throw vsError
        }
    }
    
    // Generic function for when the whole response can be parsed with JSONDecoder
    private func performRequest<T: Decodable>(url: URL) async throws -> T {
        let data: Data = try await getDataFromApi(url: url)
        let object: T = try decodeApiResponse(data: data)
        return object
    }
    
    // Articles list require special parsing logic
    private func performLoadArticleListRequest(url: URL) async throws -> ArticleListResponse {
        let data: Data = try await getDataFromApi(url: url)
        return try decodeArtlicesListResponse(data: data)
    }
}
