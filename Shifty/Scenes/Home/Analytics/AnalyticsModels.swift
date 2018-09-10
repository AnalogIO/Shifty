//
//  AnalyticsModels.swift
//  Shifty
//
//  Created by Frederik Christensen on 25/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation

enum Analytics {
    enum Fetch {
        struct Request {
            let interval: Int
        }
        struct Response {
            let values: [Int]
        }
        struct ViewModel {
            let values: [Int]
        }
    }
}
