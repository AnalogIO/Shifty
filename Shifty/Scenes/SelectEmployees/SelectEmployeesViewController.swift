//
//  EmployeesViewController.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import UIKit
import Entities
import Views

protocol SelectEmployeesDisplayLogic: class {
    func fetchEmployeesStateDidChanged(to state: State<SelectEmployees.Fetch.ViewModel>)
}
protocol SelectEmployeesDelegate: class {
    func didFinish(employeeIds: [Int])
    func didCancel()
}

class SelectEmployeesViewController: UIViewController {
    var interactor: SelectEmployeesBusinessLogic?
    var router: SelectEmployeesRoutingLogic?
    var viewModel: SelectEmployees.Fetch.ViewModel? {
        didSet {
            
            tableView.reloadData()
        }
    }
    var selectedEmployees: [Int] = []
    weak var delegate: SelectEmployeesDelegate?
    
    fileprivate lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.done,
            target: self,
            action: #selector(didPressDoneButton))
        return button
    }()
    
    fileprivate lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,
            target: self,
            action: #selector(didPressCancelButton))
        return button
    }()
    
    fileprivate lazy var activityIndicator: FDCActivityIndicator = {
        let view = FDCActivityIndicator()
        return view
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: EmployeeTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
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
        let interactor = SelectEmployeesInteractor()
        let presenter = SelectEmployeesPresenter()
        let router = SelectEmployeesRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Employees"
        view.backgroundColor = Color.background
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
        interactor?.fetchEmployees()
    }
    
    private func configureViews() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    @objc func didPressDoneButton(sender: UIBarButtonItem) {
        delegate?.didFinish(employeeIds: selectedEmployees.map { $0 })
        router?.didPressDoneButton()
    }
    
    @objc func didPressCancelButton(sender: UIBarButtonItem) {
        delegate?.didCancel()
        router?.didPressCancelButton()
    }
}

extension SelectEmployeesViewController: SelectEmployeesDisplayLogic {
    func fetchEmployeesStateDidChanged(to state: State<SelectEmployees.Fetch.ViewModel>) {
        switch state {
        case .loading:
            self.activityIndicator.start()
        case .loaded(let viewModel):
            self.viewModel = viewModel
            self.activityIndicator.stop()
        case .error(let error):
            self.activityIndicator.stop()
            showErrorMessage(message: "\(error)", actionTitle: "Retry", didPressAction: { _ in
                self.interactor?.fetchEmployees()
            })
        default:
            break
        }
    }
}

extension SelectEmployeesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = viewModel, let cell = tableView.cellForRow(at: indexPath) else { return }
        let employee = viewModel.employees[indexPath.row]
        let index = selectedEmployees.index { $0 == employee.id }
        if let index = index {
            selectedEmployees.remove(at: index)
            cell.accessoryType = .none
        } else {
            selectedEmployees.append(employee.id)
            cell.accessoryType = .checkmark
        }
    }
}

extension SelectEmployeesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel, let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.reuseIdentifier, for: indexPath) as? EmployeeTableViewCell else { return UITableViewCell() }
        let employee = viewModel.employees[indexPath.row]
        cell.configure(employee: employee)
        cell.accessoryType = selectedEmployees.contains(employee.id) ? .checkmark : .none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.employees.count
    }
}
