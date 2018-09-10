//
//  Statistics.swift
//  ClipCardAPI
//
//  Created by Frederik Christensen on 26/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Entities
import Client

extension ChartData {
    public static func getStatistics(interval: Int) -> Request<ChartData> {
        return Request(path: "/statistics/peak?interval=\(interval)", parser: ChartData.init, error: ClipCardError.init)
    }
}
