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

struct Article: Decodable, Identifiable {
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
        // TODO: better way to handle than just make optional?
        date = dateStr.toDate(DateFormats.full)
        image = try dataContainer.decode(Image.self, forKey: DataKeys.image)
        url = try dataContainer.decode(String.self, forKey: DataKeys.url)
        print("> Article - id: \(id) - title: \(title) - text: \(text)")
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

/*
 {
     "type": "news_overview",
     "analytics": {
         "oewa": "news",
         "google": "news"
     },
     "data": {
         "fussball": [{
             "type": "news_small",
             "data": {
                 "id": 2247189,
                 "title": "Premier League JETZT LIVE: Manchester City - Wolverhampton",
 */

/*
 "fussball": [{
             "type": "news_small",
             "data": {
                 "id": 2247189,
                 "title": "Premier League JETZT LIVE: Manchester City - Wolverhampton",
                 "text": "Punktverluste unerwünscht! Manchester City geht in der ungewohnten Rolle des Jägers in den nächsten Premier-League-Spieltag. LIVE-Infos:",
                 "category": {
                     "filterId": 34097,
                     "filterTitle": "fussball",
                     "id": 34097,
                     "title": "Fussball",
                     "icon": "fussball"
                 },
                 "posting": {
                     "id": 2247189,
                     "count": 0
                 },
                 "date": "2023-01-22T15:00:01+0100",
                 "image": {
                     "small": "https:\/\/www.laola1.at\/images\/redaktion\/images\/Fussball\/International\/England\/2022-23\/city-grealish-jubel_c2d29_f_512x288.jpg",
                     "medium": "https:\/\/www.laola1.at\/images\/redaktion\/images\/Fussball\/International\/England\/2022-23\/city-grealish-jubel_c1515_f_1024x576.jpg",
                     "large": "https:\/\/www.laola1.at\/images\/redaktion\/images\/Fussball\/International\/England\/2022-23\/city-grealish-jubel_bc22d_f_1920x1080.jpg"
                 },
                 "url": "https:\/\/www.laola1.at\/de\/red\/fussball\/international\/england\/premier-league\/spielbericht\/premier-league-heute--manchester-city---wolverhampton\/",
                 "app": "https:\/\/www.laola1.at\/de\/red\/fussball\/international\/england\/premier-league\/spielbericht\/premier-league-heute--manchester-city---wolverhampton\/?app"
             }
         }
 */

/*
 "motorsport": [{
             "type": "news_small",
             "data": {
                 "id": 2246754,
                 "title": "Formel-1-Neuling Nyck de Vries muss vor Gericht",
                 "text": "Der neue Pilot von Alpha Tauri wird vom Immobilienmillionär Jeroen Schothorst verklagt. Grund sind Darlehen, die de Vries' Karriere förderten.",
                 "category": {
                     "filterId": 34099,
                     "filterTitle": "motorsport",
                     "id": 34099,
                     "title": "Motorsport",
                     "icon": "motorsport"
                 },
                 "posting": {
                     "id": 2246754,
                     "count": 0
                 },
                 "date": "2023-01-19T23:34:33+0100",
                 "image": {
                     "small": "https:\/\/www.laola1.at\/images\/redaktion\/images\/Motorsport\/Formel1\/de_vries_190123_eb19d_f_512x288.jpg",
                     "medium": "https:\/\/www.laola1.at\/images\/redaktion\/images\/Motorsport\/Formel1\/de_vries_190123_5b4b2_f_1024x576.jpg",
                     "large": "https:\/\/www.laola1.at\/images\/redaktion\/images\/Motorsport\/Formel1\/de_vries_190123_21502_f_1920x1080.jpg"
                 },
                 "url": "https:\/\/www.laola1.at\/de\/red\/motorsport\/formel-1\/news\/formel-1-neuling-nyck-de-vries-muss-vor-gericht\/",
                 "app": "https:\/\/www.laola1.at\/de\/red\/motorsport\/formel-1\/news\/formel-1-neuling-nyck-de-vries-muss-vor-gericht\/?app"
             }
         }
 */

/*
 "add": {
             "1": {
                 "type": "ad_banner",
                 "data": {
                     "id": 3366048,
                     "sticky": false
                 }
             },
 */
