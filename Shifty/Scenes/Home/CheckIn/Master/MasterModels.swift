//
//  MasterModels.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities

enum Master {
    enum Fetch {
        struct Request {}
        struct Response {
            let shifts: Shifts
        }
        struct ViewModel {
            let shiftIds: [Int]
            let shiftCellConfigs: [ShiftCellConfig]
        }
    }
}
