//
//  Token.swift
//  Entities
//
//  Created by Frederik Christensen on 06/06/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Freddy

public struct Token {
    public let value: String
}

extension Token: JSONDecodable {
    public init(json: JSON) throws {
        value = try json.decode(at: "token")
    }
}
