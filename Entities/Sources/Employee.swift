//
//  Employee.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Freddy

public struct Employee {
    public let id: Int
    public let firstName: String
    public let lastName: String
}

extension Employee: JSONDecodable {
    public init(json: JSON) throws {
        id = try json.decode(at: "id")
        firstName = try json.decode(at: "firstName")
        lastName = try json.decode(at: "lastName")
    }
}
