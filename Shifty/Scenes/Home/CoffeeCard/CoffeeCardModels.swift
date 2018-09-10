//
//  CoffeeCardModels.swift
//  CheckIn
//
//  Created by Frederik Christensen on 23/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities

enum CoffeeCard {
    enum FetchToken {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }
    enum VerifyToken {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }
    enum FetchProducts {
        struct Request {}
        struct Response {
            let products: [Product]
        }
        struct ViewModel {
            let cellConfigs: [ProductCellConfig]
        }
    }
    enum IssueTickets {
        struct Request {
            let productId: Int
            let customerId: String
            let initials: String
        }
        struct Response {}
        struct ViewModel {}
    }
}
