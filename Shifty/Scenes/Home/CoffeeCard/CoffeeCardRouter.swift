//
//  CoffeeCardRouter.swift
//  CheckIn
//
//  Created by Frederik Christensen on 23/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import UIKit

protocol CoffeeCardRoutingLogic {
    func routeToNextScene()
}

protocol CoffeeCardDataPassing {
    var dataStore: CoffeeCardDataStore? { get }
}

class CoffeeCardRouter: CoffeeCardDataPassing {
    weak var viewController: CoffeeCardViewController?
    var dataStore: CoffeeCardDataStore?
}

extension CoffeeCardRouter: CoffeeCardRoutingLogic {
    func routeToNextScene() {
        //Routing to view controller
        //let destinationVC = NextSceneViewController()
        //var destinationDS = destinationVC.router!.dataStore!
        //passDataToNextScene(source: dataStore!, destination: &destinationDS)
    }
    
    /*func passDataToNextScene(source: CoffeeCardDataStore, destination: inout NextSceneDataStore) {
     //destination.? = source.?
     }*/
}
