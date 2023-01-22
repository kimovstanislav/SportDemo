//
//  SDError+API.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 22.01.23.
//

import Foundation

extension SDError {
    init(apiError: Error, code: Int, title: String, message: String, file: String = #file, function: String = #function, line: Int = #line) {
        self.init(
            source: .api,
            code: code,
            message: message,
            isSilent: false,
            cause: apiError,
            file: file,
            function: function,
            line: line
        )
    }
}

extension SDError.Factory {
    static func makeDecodingError(cause: Error? = nil) -> SDError {
        SDError(
                source: .api,
                code: SDError.ErrorCode.errorDecodingApiResponse.rawValue,
                title: SDStrings.Error.API.title,
                message: SDStrings.Error.API.decodingApiResponseFailedMessage,
                isSilent: false,
                cause: cause
            )
    }
}
