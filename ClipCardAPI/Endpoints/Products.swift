//
//  Products.swift
//  ClipCardAPI
//
//  Created by Frederik Christensen on 08/06/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation

import Entities
import Client

extension Products {
    public static func get() -> Request<Products> {
        return Request(path: "/products", parser: Products.init, error: ClipCardError.init)
    }
    public static func issue() -> RequestNoContent {
        return RequestNoContent(path: "/account/issueproduct", error: ClipCardError.init)
    }
}
