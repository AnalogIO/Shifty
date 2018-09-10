//
//  MasterViewController.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import UIKit
import Views
import Entities

protocol MasterDisplayLogic: class {
    func fetchShiftsStateDidChanged(to state: State<Master.Fetch.ViewModel>)
}

class MasterViewController: UIViewController {
    var interactor: MasterBusinessLogic?
    var router: MasterRoutingLogic?
    var viewModel: Master.Fetch.ViewModel? {
        didSet {
            navigationItem.rightBarButtonItem = viewModel != nil ? addShiftButton : nil
            tableView.reloadData()
        }
    }
    
    fileprivate lazy var activityIndicator: FDCActivityIndicator = {
        let view = FDCActivityIndicator()
        return view
    }()
    
    fileprivate lazy var addShiftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.add,
            target: self,
            action: #selector(didPressAddShift))
        return button
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(ShiftTableViewCell.self, forCellReuseIdentifier: ShiftTableViewCell.reuseIdentifier)
        return tableView
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
        let interactor = MasterInteractor()
        let presenter = MasterPresenter()
        let router = MasterRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchShifts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shifts"
        view.backgroundColor = Color.background
        self.navigationItem.rightBarButtonItem = addShiftButton
    }
    
    private func configureViews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.bringSubview(toFront: activityIndicator)
    }
    
    @objc func didPressAddShift(sender: UIBarButtonItem) {
        router?.didPressAddShift()
    }
}

extension MasterViewController: MasterDisplayLogic {
    func fetchShiftsStateDidChanged(to state: State<Master.Fetch.ViewModel>) {
        switch state {
        case .loading:
            self.activityIndicator.start()
        case .loaded(let viewModel):
            self.viewModel = viewModel
            self.activityIndicator.stop()
        case .error(let error):
            self.activityIndicator.stop()
            showErrorMessage(message: "\(error)", actionTitle: "Retry", didPressAction: { _ in
                self.interactor?.fetchShifts()
            })
        default:
            break
        }
    }
}

extension MasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        router?.didSelectRow(with: viewModel.shiftIds[indexPath.row])
    }
}

extension MasterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel, let cell = tableView.dequeueReusableCell(withIdentifier: ShiftTableViewCell.reuseIdentifier, for: indexPath) as? ShiftTableViewCell else { return UITableViewCell() }
        let config = viewModel.shiftCellConfigs[indexPath.row]
        cell.configure(cellConfig: config)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.shiftCellConfigs.count
    }
}
