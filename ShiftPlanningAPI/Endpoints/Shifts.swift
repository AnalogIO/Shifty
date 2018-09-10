//
//  Shifts+Decodable.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities
import Client

extension Shifts {
    public static func getShifts() -> Request<Shifts> {
        return Request(path: "/shifts/today", parser: Shifts.init, error: ShiftPlanningError.init)
    }
    public static func createShift() -> Request<Shift> {
        return Request(path: "/shifts", parser: Shift.init, error: ShiftPlanningError.init)
    }
}
