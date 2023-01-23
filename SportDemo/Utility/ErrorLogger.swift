//
//  ErrorLogger.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 23.01.23.
//

import Foundation

class ErrorLogger {
    static func logError(_ error: SDError) {
        // Could properly log an error here like with Firebase of whatever
        print("Error \(error.code): \(error.message)")
    }
}
