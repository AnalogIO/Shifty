//
//  DetailViewController.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import UIKit
import Entities
import Views

protocol DetailDisplayLogic: class {
    func checkInStateDidChanged(to state: State<Detail.CheckInOut.ViewModel>)
    func fetchShiftStateDidChanged(to state: State<Detail.FetchShift.ViewModel>)
    func deleteShiftStateDidChanged(to state: State<Detail.DeleteShift.ViewModel>)
    func updateEmployeesStateDidChanged(to state: State<Detail.UpdateEmployees.ViewModel>)
}

class DetailViewController: UIViewController {
    var interactor: DetailBusinessLogic?
    var router: DetailRoutingLogic?
    let shiftId: Int
    var viewModel: Detail.FetchShift.ViewModel? {
        didSet {
            if let viewModel = viewModel {
                if viewModel.isDelible {
                    navigationItem.rightBarButtonItems = [updateEmployeesButton, deleteShiftButton]
                } else {
                    navigationItem.rightBarButtonItems = [updateEmployeesButton]
                }
            } else {
                navigationItem.rightBarButtonItems = nil
            }
            tableView.reloadData()
        }
    }
    
    public init(shiftId: Int) {
        self.shiftId = shiftId
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    fileprivate lazy var updateEmployeesButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.add,
            target: self,
            action: #selector(didPressAddEmployees))
        return button
    }()
    
    fileprivate lazy var deleteShiftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.trash,
            target: self,
            action: #selector(didTapDeleteButton))
        return button
    }()
    
    fileprivate lazy var activityIndicator: FDCActivityIndicator = {
        let view = FDCActivityIndicator()
        return view
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.tableFooterView = UIView()
        tableView.register(CheckInTableViewCell.self, forCellReuseIdentifier: CheckInTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let viewController = self
        let interactor = DetailInteractor()
        let presenter = DetailPresenter()
        let router = DetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchShift(shiftId: shiftId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("detail: viewDidLoad")
        title = "Check In"
        view.backgroundColor = Color.background
        configureViews()
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
    
    public func fetchShift(shiftId: Int) {
        let request = Detail.FetchShift.Request(shiftId: shiftId)
        interactor?.fetchShift(request: request)
    }
    
    public func updateEmployees(employeeIds: [Int]) {
        guard let viewModel = viewModel else { return }
        let request = Detail.UpdateEmployees.Request(shiftId: viewModel.shiftId, employeeIds: employeeIds)
        interactor?.didUpdateEmployees(request: request)
    }
    
    @objc private func switchValueDidChange(sender: UISwitch) {
        guard let viewModel = viewModel else { return }
        let request = Detail.CheckInOut.Request(shiftId: viewModel.shiftId, employeeId: sender.tag)
        interactor?.switchValueDidChange(to: sender.isOn, request: request)
    }
    
    @objc func didPressAddEmployees(sender: UIBarButtonItem) {
        router?.didPressAddEmployees()
    }
    
    @objc func didTapDeleteButton(sender: UIBarButtonItem) {
        guard let viewModel = viewModel else { return }
        let request = Detail.DeleteShift.Request(shiftId: viewModel.shiftId)
        interactor?.didTapDeleteButton(request: request)
    }
}

extension DetailViewController: DetailDisplayLogic {
    func updateEmployeesStateDidChanged(to state: State<Detail.UpdateEmployees.ViewModel>) {
        switch state {
        case .loading:
            self.activityIndicator.start()
        case .loaded(_):
            self.activityIndicator.stop()
            fetchShift(shiftId: shiftId)
        case .error(let error):
            self.activityIndicator.stop()
            showErrorMessage(message: "\(error)", actionTitle: "Ok", didPressAction: { _ in
                self.fetchShift(shiftId: self.shiftId)
            })
        default:
            break
        }
    }
    
    func deleteShiftStateDidChanged(to state: State<Detail.DeleteShift.ViewModel>) {
        switch state {
        case .loading:
            self.activityIndicator.start()
        case .loaded(_):
            self.activityIndicator.stop()
            router?.didDeleteShift()
        case .error(let error):
            self.activityIndicator.stop()
            showErrorMessage(message: "\(error)", actionTitle: "Ok", didPressAction: nil)
        default:
            break
        }
    }
    
    func checkInStateDidChanged(to state: State<Detail.CheckInOut.ViewModel>) {
        switch state {
        case .loading:
            self.activityIndicator.start()
        case .loaded(_):
            self.activityIndicator.stop()
            fetchShift(shiftId: shiftId)
        case .error(let error):
            self.activityIndicator.stop()
            showErrorMessage(message: "\(error)", actionTitle: "Ok", didPressAction: { _ in
                self.fetchShift(shiftId: self.shiftId)
            })
        default:
            break
        }
    }
    
    func fetchShiftStateDidChanged(to state: State<Detail.FetchShift.ViewModel>) {
        switch state {
        case .loading:
            self.activityIndicator.start()
        case .loaded(let viewModel):
            self.activityIndicator.stop()
            self.viewModel = viewModel
        case .error(let error):
            self.activityIndicator.stop()
            showErrorMessage(message: "\(error)", actionTitle: "Ok", didPressAction: nil)
        default:
            break
        }
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel, let cell = tableView.dequeueReusableCell(withIdentifier: CheckInTableViewCell.reuseIdentifier, for: indexPath) as? CheckInTableViewCell else { return UITableViewCell() }
        let config = viewModel.cellConfigs[indexPath.row]
        cell.configure(cellConfig: config)
        cell.switchButton.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.cellConfigs.count
    }
}
