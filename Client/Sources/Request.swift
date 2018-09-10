//
//  Request.swift
//  ClipCard
//
//  Created by Frederik Dam Christensen on 22/02/2018.
//  Copyright © 2018 Frederik Dam Christensen. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

public struct Request<Resource> {
    
    public var path: String
    public var parser: (JSON) throws -> Resource
    public var error: (JSON) throws -> Error
    
    public init(path: String,
                parser: @escaping (JSON) throws -> Resource,
                error: @escaping (JSON) throws -> Error) {
        
        self.path = path
        self.parser = parser
        self.error = error
    }
}

extension Request {
    public func response(using api: API, method: HTTPMethod, parameters: Parameters, headers: HTTPHeaders, response: @escaping ((Response<Resource>) -> Void)) {
        api.response(for: self, method: method, parameters: parameters, headers: headers, response: response)
    }
}
