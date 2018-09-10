//
//  Product.swift
//  Entities
//
//  Created by Frederik Christensen on 08/06/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation

import Foundation
import Freddy

public struct Product {
    public let id: Int
    public let price: Int
    public let numberOfTickets: Int
    public let name: String
    public let description: String
}

extension Product: JSONDecodable {
    public init(json: JSON) throws {
        id = try json.decode(at: "id")
        price = try json.decode(at: "price")
        numberOfTickets = try json.decode(at: "numberOfTickets")
        name = try json.decode(at: "name")
        description = try json.decode(at: "description")
    }
}
