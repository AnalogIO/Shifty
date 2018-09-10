//
//  AnalyticsPresenter.swift
//  Shifty
//
//  Created by Frederik Christensen on 25/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities

protocol AnalyticsPresentationLogic {
    func fetchStatisticsStateDidChanged(to state: State<Analytics.Fetch.Response>)
}

class AnalyticsPresenter {
    weak var viewController: AnalyticsDisplayLogic?
}

extension AnalyticsPresenter: AnalyticsPresentationLogic {
    func fetchStatisticsStateDidChanged(to state: State<Analytics.Fetch.Response>) {
        switch state {
        case .loading:
            viewController?.fetchStatisticsStateDidChanged(to: .loading)
        case .loaded(let response):
            let viewModel = Analytics.Fetch.ViewModel(values: response.values)
            viewController?.fetchStatisticsStateDidChanged(to: .loaded(viewModel))
        case .error(let error):
            viewController?.fetchStatisticsStateDidChanged(to: .error(error))
        case .unknown:
            viewController?.fetchStatisticsStateDidChanged(to: .unknown)
        }
    }
}
