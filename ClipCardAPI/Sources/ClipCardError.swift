//
//  ClipCardError.swift
//  ClipCardAPI
//
//  Created by Frederik Christensen on 26/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Freddy

public struct ClipCardError: Error {
}

extension ClipCardError: JSONDecodable {
    public init(json: JSON) throws {
    }
}
