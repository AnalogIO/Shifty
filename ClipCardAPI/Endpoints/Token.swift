//
//  Token.swift
//  ClipCardAPI
//
//  Created by Frederik Christensen on 06/06/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Entities
import Client

extension Token {
    public static func get() -> Request<Token> {
        return Request(path: "/account/adminlogin", parser: Token.init, error: ClipCardError.init)
    }
    public static func verify() -> RequestNoContent {
        return RequestNoContent(path: "/account/validateadmintoken", error: ClipCardError.init)
    }
}
