//
//  Article.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 22.01.23.
//

import Foundation

/*struct TestCategoriesList: Decodable {
//    let testCategories: [Test]
    let testCategories: [String: [Test]]
    
    private enum CodingKeys: String, CodingKey {
        case data
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        testCategories = try container.decode([Test].self, forKey: CodingKeys.data)
//        print("> TestCategoriesList - testCategories: \(testCategories)")
//    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        testCategories = try container.decode([String: [Test]].self, forKey: CodingKeys.data)
        print("> TestCategoriesList - testCategories: \(testCategories)")
    }
}

//struct TestCategory: Decodable {
//    let tests: [Test]
//}

struct Test: Decodable, Identifiable {
    let id: Int
    let text: String
    
    private enum ContainerKeys: String, CodingKey {
        case data
    }
    
    private enum DataKeys: String, CodingKey {
        case id
        case text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContainerKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: DataKeys.self, forKey: ContainerKeys.data)
        id = try dataContainer.decode(Int.self, forKey: DataKeys.id)
        text = try dataContainer.decode(String.self, forKey: DataKeys.text)
        print("> Test - id: \(id) - text: \(text)")
    }
}*/

//// TESTING ABOVE

/*struct ArticleListResponse: Decodable {
    let categories: [String: ArticleListData]
    
    private enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // TODO: use json decoder to get all key and dictionary/array pairs. Then parse each separately with JsonDecoder.
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // try to read out a string array
                if let names = json["names"] as? [String] {
                    print(names)
                }
            }
        
        // https://stackoverflow.com/questions/44603248/how-to-decode-a-property-with-type-of-json-dictionary-in-swift-45-decodable-pr
        // https://developer.apple.com/forums/thread/100417
        // Looks like to do it dynamically would require to also add JsonDecoder, add some extra logic to mix up with JsonSerialization. Pure JsonSerialization looks impossible.
        
        
        // Do we even need to dynamically parse all the main category types? The actual categories inside elements are different. And json is complex. Maybe we don't, so let's not complicate things.
        
        // Just hardcode parse 5 main categories: fussball, wintersport, motorsport, sportmix, esports. Ignore adds.
        // There are json fields with arbitrary keys, that can also hold array (activities) or dictionary (adds). To perfectly dynamically handle it would change simple elegant code into something much more complicated and not standard. Would require deeper research to say more, but it's not straightforward to say the least.
        // I only have this json response, I don't know with which purpose it was designed that way. Don't know if these categories are higly dynamic, or are actually just hardcoded on BE side. The actual category dictionary is inside each single activity entry anyway. So I don't understand why these 5 categories fussball, wintersport, motorsport, sportmix, esports are needed at all.
        // To dynamically parse them requires too much extra code, and without a good purpose is not something I'd do. There is no such purpose for this task, as I have only 1 static json. So I will do it in the most simple and clean way. But I can justify what I'd do if more was required.
        
        let articleCategories = try container.decode([String: ArticleListData].self, forKey: CodingKeys.data)
        categories = articleCategories
        print("> ArticleCategoriesList - articles: \(articleCategories)")
    }
}*/

struct ArticleListResponse {
    let categories: [ArticleListCategory]
}

struct ArticleListCategory {
    let name: String
    let articles: [Article]
    
    // TODO: add enum, rename, so also has adds
}

struct Article: Decodable, Identifiable {
    let id: Int
    let title: String
    let text: String
    let category: Category
    let date: Date
    let image: Image
    let url: String
    let type: String
    
    var displayDate: String {
        date.toString(DateFormats.display)
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
        // TODO: handle if failed to format?
        date = dateStr.toDate(DateFormats.full)!
        image = try dataContainer.decode(Image.self, forKey: DataKeys.image)
        url = try dataContainer.decode(String.self, forKey: DataKeys.url)
        print("> Article - id: \(id) - title: \(title) - text: \(text)")
    }
}

//struct Add: Decodable {
//    let value: [String: Data]
//
//    struct Value: Decodable {
//        let type: String
//        let data: Data
//    }
//
//    struct Data: Decodable {
//        let id: Int
//        let sticky: Bool
//    }
//}

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
