//
//  APIClient+ErrorMapping.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 23.01.23.
//

import Foundation

extension APIClient {
    enum ErrorMapper {
        static func convertToSDError(_ error: Error) -> SDError {
            if let error = error as NSError? {
                return parseError(error)
            }
            else {
                return SDError.unknown
            }
        }

        private static func parseError(_ error: NSError) -> SDError{
            if error.code == URLError.notConnectedToInternet.rawValue || error.code == URLError.cannotConnectToHost.rawValue {
                return SDError(apiError: error, code: error.code, title: SDStrings.Error.API.noInternetConnectionTitle, message: SDStrings.Error.API.noInternetConnectionMessage)
            }
            else if error.code == HTTPStatusCode.internalServerError.rawValue {
                return SDError(apiError: error, code: error.code, title: SDStrings.Error.API.internalServerErrorTitle, message: SDStrings.Error.API.internalServerErrorMessage)
            }
            return SDError(apiError: error, code: error.code, title: SDStrings.Error.API.title, message: error.localizedDescription)
        }
    }
}
