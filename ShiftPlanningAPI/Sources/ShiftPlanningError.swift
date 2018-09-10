//
//  ShiftPlanningError.swift
//  CheckIn
//
//  Created by Frederik Christensen on 23/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Freddy

public struct ShiftPlanningError: Error {
    public let message: String
}

extension ShiftPlanningError: JSONDecodable {
    public init(json: JSON) throws {
        message = try json.decode(at: "message")
    }
}
