//
//  JsonHelper.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 22.01.23.
//

import Foundation

enum JsonHelper {
    static func readJsonString(named: String) -> String {
        if let path = Bundle.main.path(forResource: named, ofType: "json") {
            return (try? String(contentsOfFile: path)) ?? ""
        }
        return ""
    }
}
