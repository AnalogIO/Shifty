//
//  AnalyticsViewController.swift
//  Shifty
//
//  Created by Frederik Christensen on 25/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import UIKit
import Views
import Entities

protocol AnalyticsDisplayLogic: class {
    func fetchStatisticsStateDidChanged(to state: State<Analytics.Fetch.ViewModel>)
}

class AnalyticsViewController: UIViewController {
    var interactor: AnalyticsBusinessLogic?
    var router: AnalyticsRoutingLogic?
    let interval: Int = 15
    var viewModel: Analytics.Fetch.ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            graphView.setData(interval: Double(interval), data: viewModel.values)
        }
    }
    
    fileprivate lazy var activityIndicator: FDCActivityIndicator = {
        let view = FDCActivityIndicator()
        return view
    }()
    
    fileprivate lazy var graphView: GraphView = {
        let graphView = GraphView()
        return graphView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let viewController = self
        let interactor = AnalyticsInteractor()
        let presenter = AnalyticsPresenter()
        let router = AnalyticsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let request = Analytics.Fetch.Request(interval: interval)
        interactor?.fetchStatistics(request: request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Analytics"
        view.backgroundColor = Color.background      
    }
    
    private func configureViews() {
        view.addSubview(graphView)
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        graphView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.bringSubview(toFront: activityIndicator)
    }
}

extension AnalyticsViewController: AnalyticsDisplayLogic {
    func fetchStatisticsStateDidChanged(to state: State<Analytics.Fetch.ViewModel>) {
        switch state {
        case .loading:
            self.activityIndicator.start()
        case .loaded(let viewModel):
            self.viewModel = viewModel
            self.activityIndicator.stop()
        case .error(let error):
            self.activityIndicator.stop()
            showErrorMessage(message: "\(error)", actionTitle: "Ok", didPressAction: nil)
        default:
            break
        }
    }
}
