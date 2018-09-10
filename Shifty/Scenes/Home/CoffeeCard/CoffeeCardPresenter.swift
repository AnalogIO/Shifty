//
//  CoffeeCardPresenter.swift
//  CheckIn
//
//  Created by Frederik Christensen on 23/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities

protocol CoffeeCardPresentationLogic {
    func fetchTokenStateDidChanged(to state: State<CoffeeCard.FetchToken.Response>)
    func fetchProductsStateDidChanged(to: State<CoffeeCard.FetchProducts.Response>)
    func issueTicketsStateDidChanged(to: State<CoffeeCard.IssueTickets.Response>)
    func verifyTokenStateDidChanged(to state: State<CoffeeCard.VerifyToken.Response>)
}

class CoffeeCardPresenter {
    weak var viewController: CoffeeCardDisplayLogic?
}

extension CoffeeCardPresenter: CoffeeCardPresentationLogic {
    func issueTicketsStateDidChanged(to state: State<CoffeeCard.IssueTickets.Response>) {
        switch state {
        case .loading:
            viewController?.issueTicketsStateDidChanged(to: .loading)
        case .loaded(_):
            let viewModel = CoffeeCard.IssueTickets.ViewModel()
            viewController?.issueTicketsStateDidChanged(to: .loaded(viewModel))
        case .error(let error):
            viewController?.issueTicketsStateDidChanged(to: .error(error))
        case .unknown:
            viewController?.issueTicketsStateDidChanged(to: .unknown)
        }
    }
    
    func fetchProductsStateDidChanged(to state: State<CoffeeCard.FetchProducts.Response>) {
        switch state {
        case .loading:
            viewController?.fetchProductsStateDidChanged(to: .loading)
        case .loaded(let products):
            let configs = products.products.map {
                return ProductCellConfig(name: $0.name, id: $0.id)
            }
            let viewModel = CoffeeCard.FetchProducts.ViewModel(cellConfigs: configs)
            viewController?.fetchProductsStateDidChanged(to: .loaded(viewModel))
        case .error(let error):
            viewController?.fetchProductsStateDidChanged(to: .error(error))
        case .unknown:
            viewController?.fetchProductsStateDidChanged(to: .unknown)
        }
    }
    
    func verifyTokenStateDidChanged(to state: State<CoffeeCard.VerifyToken.Response>) {
        switch state {
        case .loading:
            viewController?.verifyTokenStateDidChanged(to: .loading)
        case .loaded(_):
            let viewModel = CoffeeCard.VerifyToken.ViewModel()
            viewController?.verifyTokenStateDidChanged(to: .loaded(viewModel))
        case .error(let error):
            viewController?.verifyTokenStateDidChanged(to: .error(error))
        case .unknown:
            viewController?.verifyTokenStateDidChanged(to: .unknown)
        }
    }
    
    func fetchTokenStateDidChanged(to state: State<CoffeeCard.FetchToken.Response>) {
        switch state {
        case .loading:
            viewController?.fetchTokenStateDidChanged(to: .loading)
        case .loaded(_):
            let viewModel = CoffeeCard.FetchToken.ViewModel()
            viewController?.fetchTokenStateDidChanged(to: .loaded(viewModel))
        case .error(let error):
            viewController?.fetchTokenStateDidChanged(to: .error(error))
        case .unknown:
            viewController?.fetchTokenStateDidChanged(to: .unknown)
        }
    }
}
