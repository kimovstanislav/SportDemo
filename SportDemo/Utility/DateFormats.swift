//
//  DateFormats.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 22.01.23.
//

import Foundation

enum DateFormats {
    static let full = "YYYY-MM-dd'T'HH:mm:ssZ"
    // 2023-01-22T15:00:01+0100
    // "2022-08-10T10:10:49+0200"
    static let display = "YYYY-MM-dd HH:mm"
}

extension String {
    func toDate(_ format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func toString(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
