//
//  Shifts.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Freddy

public struct Shifts {
    public let shifts: [Shift]
}

extension Shifts: JSONDecodable {
    public init(json: JSON) throws {
        shifts = try json.decodedArray(type: Shift.self)
    }
}
