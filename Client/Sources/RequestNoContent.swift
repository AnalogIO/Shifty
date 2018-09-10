//
//  RequestNoContent.swift
//  Client
//
//  Created by Frederik Christensen on 25/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

public struct RequestNoContent {
    
    public var path: String
    public var error: (JSON) throws -> Error
    
    public init(path: String,
                error: @escaping (JSON) throws -> Error) {
        
        self.path = path
        self.error = error
    }
}

extension RequestNoContent {
    public func response(using api: API, method: HTTPMethod, parameters: Parameters, headers: HTTPHeaders, response: @escaping ((ResponseNoContent) -> Void)) {
        api.responseNoContent(for: self, method: method, parameters: parameters, headers: headers, response: response)
    }
}
