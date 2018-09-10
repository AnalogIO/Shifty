//
//  DetailModels.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities

enum Detail {
    enum DeleteShift {
        struct Request {
            let shiftId: Int
        }
        struct Response {}
        struct ViewModel {}
    }
    enum FetchShift {
        struct Request {
            let shiftId: Int
        }
        struct Response {
            let shift: Shift
        }
        struct ViewModel {
            let shiftId: Int
            let cellConfigs: [CheckInCellConfig]
            let employeeIds: [Int]
            let isDelible: Bool
        }
    }
    enum CheckInOut {
        struct Request {
            let shiftId: Int
            let employeeId: Int
        }
        struct Response {}
        struct ViewModel {}
    }
    enum UpdateEmployees {
        struct Request {
            let shiftId: Int
            let employeeIds: [Int]
        }
        struct Response {}
        struct ViewModel {}
    }
}
