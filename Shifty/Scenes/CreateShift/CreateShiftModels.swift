//
//  CreateShiftModels.swift
//  CheckIn
//
//  Created by Frederik Christensen on 19/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities

enum CreateShift {
    struct Request {
        let employeeIds: [Int]
        let start: Date
        let end: Date
    }
    struct Response {
        let shift: Shift
    }
    struct ViewModel {}
}
