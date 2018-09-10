//
//  Employee+Decodable.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities
import Client

extension Employee {
    public static func checkIn(shiftId: Int, employeeId: Int) -> RequestNoContent {
        return RequestNoContent(path: "/shifts/\(shiftId)/checkin?employeeId=\(employeeId)", error: ShiftPlanningError.init)
    }
    public static func checkOut(shiftId: Int, employeeId: Int) -> RequestNoContent {
        return RequestNoContent(path: "/shifts/\(shiftId)/checkout?employeeId=\(employeeId)", error: ShiftPlanningError.init)
    }
}
