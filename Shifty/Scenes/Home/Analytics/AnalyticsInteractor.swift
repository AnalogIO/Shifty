//
//  AnalyticsInteractor.swift
//  Shifty
//
//  Created by Frederik Christensen on 25/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import ClipCardAPI
import Entities
import Client

protocol AnalyticsBusinessLogic {
    func fetchStatistics(request: Analytics.Fetch.Request)
}

protocol AnalyticsDataStore {}

class AnalyticsInteractor: AnalyticsDataStore {
    var presenter: AnalyticsPresentationLogic?
    
    fileprivate var fetchStatisticsState: State<Analytics.Fetch.Response> = .unknown {
        didSet {
            self.presenter?.fetchStatisticsStateDidChanged(to: fetchStatisticsState)
        }
    }
}

extension AnalyticsInteractor: AnalyticsBusinessLogic {
    func fetchStatistics(request: Analytics.Fetch.Request) {
        let api = ClipCardAPI()
        fetchStatisticsState = .loading
        ChartData.getStatistics(interval: request.interval).response(using: api, method: .get, parameters: [:], headers: [:]) { [weak self](response: Response<ChartData>) in
            switch response {
            case .success(let values):
                let response = Analytics.Fetch.Response(values: values.data)
                self?.fetchStatisticsState = .loaded(response)
            case .error(let error):
                self?.fetchStatisticsState = .error(error)
            }
        }
    }
}
