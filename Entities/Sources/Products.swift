//
//  Products.swift
//  Entities
//
//  Created by Frederik Christensen on 08/06/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Freddy

public struct Products {
    public let products: [Product]
}

extension Products: JSONDecodable {
    public init(json: JSON) throws {
        products = try json.decodedArray(type: Product.self)
    }
}
