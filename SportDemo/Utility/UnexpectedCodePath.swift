//
//  UnexpectedCodePath.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 23.01.23.
//

import Foundation

/// Crashes the app when an unexpected code path is executed and logs the error
func unexpectedCodePath(message: String, file: String = #file, line: Int = #line, function: String = #function) -> Never {
    let error = SDError(source: .unknown, code: SDError.ErrorCode.unexpectedCodePath.rawValue, title: "Unexpected Code Path", message: message)
    // Could also log this error here, if had any logging like Firebase or whatever.
    print("Unexpected code path error: \(error)")
    fatalError(message)
}
