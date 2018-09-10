//
//  CoffeeCardInteractor.swift
//  CheckIn
//
//  Created by Frederik Christensen on 23/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities
import Client
import ClipCardAPI

protocol CoffeeCardBusinessLogic {
    func viewWillAppear()
    func issueTickets(request: CoffeeCard.IssueTickets.Request)
    func tokenIsValid()
    func tokenIsInvalid()
}

protocol CoffeeCardDataStore {}

class CoffeeCardInteractor: CoffeeCardDataStore {
    var presenter: CoffeeCardPresentationLogic?
    
    fileprivate var fetchTokenState: State<CoffeeCard.FetchToken.Response> = .unknown {
        didSet {
            self.presenter?.fetchTokenStateDidChanged(to: fetchTokenState)
        }
    }
    
    fileprivate var verifyTokenState: State<CoffeeCard.VerifyToken.Response> = .unknown {
        didSet {
            self.presenter?.verifyTokenStateDidChanged(to: verifyTokenState)
        }
    }
    
    fileprivate var fetchProductsState: State<CoffeeCard.FetchProducts.Response> = .unknown {
        didSet {
            self.presenter?.fetchProductsStateDidChanged(to: fetchProductsState)
        }
    }
    
    fileprivate var issueTicketsState: State<CoffeeCard.IssueTickets.Response> = .unknown {
        didSet {
            self.presenter?.issueTicketsStateDidChanged(to: issueTicketsState)
        }
    }
    
    private func fetchToken() {
        let api = ClipCardAPI()
        fetchTokenState = .loading
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        let parameters = [
            "email": Config.email,
            "password": Config.password.sha256(),
            "version": version
        ]
        Token.get().response(using: api, method: .post, parameters: parameters, headers: [:]) { [weak self](response: Response<Token>) in
            switch response {
            case .success(let token):
                KeyChainService.shared.store(key: .token, value: token.value)
                let response = CoffeeCard.FetchToken.Response()
                self?.fetchTokenState = .loaded(response)
                self?.fetchProducts()
            case .error(let error):
                self?.fetchTokenState = .error(error)
            }
        }
    }
    
    private func fetchProducts() {
        let api = ClipCardAPI()
        fetchProductsState = .loading
        guard let token = KeyChainService.shared.get(key: .token) else { return }
        let headers = [
            "Authorization": token
        ]
        Products.get().response(using: api, method: .get, parameters: [:], headers: headers) { [weak self](response: Response<Products>) in
            switch response {
            case .success(let products):
                let response = CoffeeCard.FetchProducts.Response(products: products.products)
                self?.fetchProductsState = .loaded(response)
            case .error(let error):
                self?.fetchProductsState = .error(error)
            }
        }
    }
    
    private func verifyToken() {
        let api = ClipCardAPI()
        verifyTokenState = .loading
        guard let token = KeyChainService.shared.get(key: .token) else { return }
        let headers = [
            "Authorization": token
        ]
        Token.verify().response(using: api, method: .post, parameters: [:], headers: headers) { [weak self](response: ResponseNoContent) in
            switch response {
            case .success:
                let response = CoffeeCard.VerifyToken.Response()
                self?.verifyTokenState = .loaded(response)
            case .error(let error):
                self?.verifyTokenState = .error(error)
            }
        }
    }
}

extension CoffeeCardInteractor: CoffeeCardBusinessLogic {
    func tokenIsValid() {
        fetchProducts()
    }
    
    func tokenIsInvalid() {
        fetchToken()
    }
    
    func issueTickets(request: CoffeeCard.IssueTickets.Request) {
        let api = ClipCardAPI()
        issueTicketsState = .loading
        guard let token = KeyChainService.shared.get(key: .token) else { return }
        let parameters: [String:Any] = [
            "userId": request.customerId,
            "productId": "\(request.productId)",
            "issuedBy": request.initials
        ]
        let headers = [
            "Authorization": token
        ]
        Products.issue().response(using: api, method: .post, parameters: parameters, headers: headers) { [weak self](response: ResponseNoContent) in
            switch response {
            case .success:
                let response = CoffeeCard.IssueTickets.Response()
                self?.issueTicketsState = .loaded(response)
            case .error(let error):
                self?.issueTicketsState = .error(error)
            }
        }
    }
    
    func viewWillAppear() {
        if(!KeyChainService.shared.exists(key: .token)) {
            fetchToken()
        } else {
            verifyToken()
        }
    }
}
