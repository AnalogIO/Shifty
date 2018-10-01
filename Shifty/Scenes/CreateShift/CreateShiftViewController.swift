//
//  CreateShiftViewController.swift
//  CheckIn
//
//  Created by Frederik Christensen on 19/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import UIKit
import Entities
import Views

protocol CreateShiftDisplayLogic: class {
    func createShiftStateDidChanged(to state: State<CreateShift.ViewModel>)
}

protocol CreateShiftDelegate: class {
    func didCreateShift()
}

class CreateShiftViewController: UIViewController {
    var interactor: CreateShiftBusinessLogic?
    var router: CreateShiftRoutingLogic?
    weak var delegate: CreateShiftDelegate?
    var selectedEmployees: [Int] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var fromCell, toCell: DatePickerTableViewCell?
    
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        tableView.tableFooterView = UIView()
        tableView.register(SelectEmployeesCell.self, forCellReuseIdentifier: SelectEmployeesCell.reuseIdentifier)
        tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: DatePickerTableViewCell.reuseIdentifier)
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
        let interactor = CreateShiftInteractor()
        let presenter = CreateShiftPresenter()
        let router = CreateShiftRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background
        title = "Create Shift"
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
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
        
        view.bringSubviewToFront(activityIndicator)
    }
    
    @objc func didPressDoneButton(sender: UIBarButtonItem) {
        guard let fromCell = fromCell, let toCell = toCell else { return }
        let request = CreateShift.Request(employeeIds: selectedEmployees, start: fromCell.getDate(), end: toCell.getDate())
        interactor?.createShift(request: request)
    }
    
    @objc func didPressCancelButton(sender: UIBarButtonItem) {
        router?.didPressCancelButton()
    }
}

extension CreateShiftViewController: CreateShiftDisplayLogic {
    func createShiftStateDidChanged(to state: State<CreateShift.ViewModel>) {
        switch state {
        case .loading:
            self.activityIndicator.start()
        case .loaded(_):
            self.activityIndicator.stop()
            router?.didCreateShift()
            delegate?.didCreateShift()
        case .error(let error):
            self.activityIndicator.stop()
            showErrorMessage(message: "\(error)", actionTitle: "Ok", didPressAction: nil)
        default:
            break
        }
    }
}

extension CreateShiftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 { router?.didPressAddEmployees() }
    }
}

extension CreateShiftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectEmployeesCell.reuseIdentifier, for: indexPath) as? SelectEmployeesCell else { return UITableViewCell() }
            cell.textLabel?.text = "Select Employees"
            cell.detailTextLabel?.text = "\(selectedEmployees.count)"
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.reuseIdentifier, for: indexPath) as? DatePickerTableViewCell else { return UITableViewCell() }
            fromCell = cell
            cell.setTitle("Select Start")
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.reuseIdentifier, for: indexPath) as? DatePickerTableViewCell else { return UITableViewCell() }
            toCell = cell
            cell.setTitle("Select End")
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}
