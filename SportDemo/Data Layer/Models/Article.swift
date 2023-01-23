//
//  Article.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 22.01.23.
//

import Foundation

struct ArticleListResponse {
    let sections: [ArticleListSection]
}

struct ArticleListSection {
    let data: Data
    
    enum Data {
        /// Parameters: name, array of articles
        case articlesCategory(String, [Article])
        /// Parameters: add
        case add(AddSection)
    }
}

struct Article: Decodable, Identifiable, Equatable {
    let id: Int
    let title: String
    let text: String
    let category: Category
    let date: Date?
    let image: Image
    let url: String
    let type: String
    
    var displayDate: String {
        guard let dateValue = date else { return "" }
        return dateValue.toString(DateFormats.display)
    }
    
    struct Category: Decodable, Identifiable {
        let id: Int
        let filterId: Int
        let filterTitle: String
        let title: String
        let icon: String
    }
    
    struct Image: Decodable {
        let small: String
        let medium: String
        let large: String
    }
    
    private enum ContainerKeys: String, CodingKey {
        case data
        case type
    }
    private enum DataKeys: String, CodingKey {
        case id
        case title
        case text
        case category
        case date
        case image
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContainerKeys.self)
        type = try container.decode(String.self, forKey: ContainerKeys.type)
        let dataContainer = try container.nestedContainer(keyedBy: DataKeys.self, forKey: ContainerKeys.data)
        id = try dataContainer.decode(Int.self, forKey: DataKeys.id)
        title = try dataContainer.decode(String.self, forKey: DataKeys.title)
        text = try dataContainer.decode(String.self, forKey: DataKeys.text)
        category = try dataContainer.decode(Category.self, forKey: DataKeys.category)
        let dateStr = try dataContainer.decode(String.self, forKey: DataKeys.date)
        date = dateStr.toDate(DateFormats.full)
        image = try dataContainer.decode(Image.self, forKey: DataKeys.image)
        url = try dataContainer.decode(String.self, forKey: DataKeys.url)
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.id == rhs.id
    }
}

struct AddSection {
    let adds: [Add]
    
    struct Add: Decodable {
        let name: String
        let content: Content
        
        struct Content: Decodable {
            let type: String
            let data: Data

            struct Data: Decodable {
                let id: Int
                let sticky: Bool
            }
        }
    }
}
