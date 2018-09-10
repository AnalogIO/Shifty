//
//  Shift+Decodable.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities
import Client

extension Shift {
    public static func getShift(shiftId: Int) -> Request<Shift> {
        return Request(path: "/shifts/\(shiftId)", parser: Shift.init, error: ShiftPlanningError.init)
    }
    public static func updateShift(shiftId: Int) -> RequestNoContent {
        return RequestNoContent(path: "/shifts/\(shiftId)", error: ShiftPlanningError.init)
    }
    public static func deleteShift(shiftId: Int) -> RequestNoContent {
        return RequestNoContent(path: "/shifts/\(shiftId)", error: ShiftPlanningError.init)
    }
}
