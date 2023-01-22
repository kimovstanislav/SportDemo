//
//  SDError.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 22.01.23.
//

import Foundation

struct SDError: Error {
    let source: Source
    /// The status code of the error
    let code: Int
    /// The error title
    let title: String
    /// The error message
    let message: String
    /// Indicates whether the error will be shown to the user
    let isSilent: Bool
    /// The underlying error that caused this error
    let cause: Error?
    /// Error location in code, for internal logging
    let location: String
    
    init(source: SDError.Source = .unknown, code: Int, title: String = SDStrings.Error.API.title, message: String, isSilent: Bool = false, cause: Error? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        self.source = source
        self.code = code
        self.title = title
        self.message = message + String(format: SDStrings.Error.API.formattedErrorCode, code)
        self.isSilent = isSilent
        self.cause = cause
        location = "\(file):\(line), \(function)"
    }
    
    static let unknown = SDError(
        source: .unknown,
        code: ErrorCode.unknown.rawValue,
        title: SDStrings.Error.API.title,
        message: SDStrings.Error.API.unknownMessage
    )
}

extension SDError {
    enum Source: String {
        case api, unknown
    }
}

extension SDError {
    enum ErrorCode: Int {
        case unknown = -1
        case unexpectedCodePath = 0
        // Let's have API response decoding failed error code 901
        case errorDecodingApiResponse = 901
    }
}

extension SDError {
    enum Factory {}
}
