//
//  DataError.swift
//  Osvas-iOS
//
//  Created by Ilham Hadi Prabawa on 5/6/20.
//  Copyright © 2020 Osvas. All rights reserved.
//

import Foundation

public enum NError: Equatable {
    case unauthorized
    case internalServerError
    case responseError(message: String)
    case incompleteInput
    case undefinedError
    case parseError
    case serializationError
    case notValidURL
}

public extension NError {
    var description: String {
        switch self {
        case .unauthorized:
            return "Ups! Your session has been expired. You'll be logged out."
        case let .responseError(message):
           return message
        case .incompleteInput:
            return "Incomplete input"
        case .undefinedError:
            return "Sorry please try again later"
        case .parseError:
            return "Parse error"
        case .internalServerError:
            return "Internal server error"
        case .serializationError:
            return "Problems with serialization"
        case .notValidURL:
            return "URL is not valid"
        }
    }
}

public class ErrorResponse {
    var errorResult: NError?
    
    public init(data: Data) {
        self.errorResult = decodeJson(from: data)
    }
    
    private func decodeJson(from data: Data) -> NError{
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
            if let jsonError = json["error"] as? [String: Any] {
                if let message = jsonError["message"] as? String {
                    return .responseError(message: message)
                }
                if let errors = jsonError["errors"] as? String {
                    return .responseError(message: errors)
                }
            }
        }catch let error {
            print(error.localizedDescription)
        }
        
        return .undefinedError
    }
    
}

public class DataError: Error {
    
    var data: Data?
    var errorType: NError?
    var errorModel: ErrorResponse?
    
    public init() {
        
    }
    
    public init(data: Data) {
        self.data = data
        self.errorModel = ErrorResponse(data: data)
        self.errorType = nil
    }
    
    public init(errorType: NError) {
        self.errorType = errorType
        self.data = nil
        self.errorModel = nil
    }
    
}
