//
//  ChartData.swift
//  Entities
//
//  Created by Frederik Christensen on 26/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Freddy

public struct ChartData {
    public let data: [Int]
}

extension ChartData: JSONDecodable {
    public init(json: JSON) throws {
        data = try json.decodedArray(type: Int.self)
    }
}
