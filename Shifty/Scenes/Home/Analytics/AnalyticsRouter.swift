//
//  AnalyticsRouter.swift
//  Shifty
//
//  Created by Frederik Christensen on 25/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import UIKit

protocol AnalyticsRoutingLogic {
    func routeToNextScene()
}

protocol AnalyticsDataPassing {
    var dataStore: AnalyticsDataStore? { get }
}

class AnalyticsRouter: AnalyticsDataPassing {
    weak var viewController: AnalyticsViewController?
    var dataStore: AnalyticsDataStore?
}

extension AnalyticsRouter: AnalyticsRoutingLogic {
    func routeToNextScene() {
        //Routing to view controller
        //let destinationVC = NextSceneViewController()
        //var destinationDS = destinationVC.router!.dataStore!
        //passDataToNextScene(source: dataStore!, destination: &destinationDS)
    }
    
    /*func passDataToNextScene(source: AnalyticsDataStore, destination: inout NextSceneDataStore) {
     //destination.? = source.?
     }*/
}
