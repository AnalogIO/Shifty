//
//  CoffeeCardViewController.swift
//  CheckIn
//
//  Created by Frederik Christensen on 23/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import UIKit
import Views
import Entities

protocol CoffeeCardDisplayLogic: class {
    func fetchTokenStateDidChanged(to state: State<CoffeeCard.FetchToken.ViewModel>)
    func fetchProductsStateDidChanged(to state: State<CoffeeCard.FetchProducts.ViewModel>)
    func issueTicketsStateDidChanged(to state: State<CoffeeCard.IssueTickets.ViewModel>)
    func verifyTokenStateDidChanged(to state: State<CoffeeCard.VerifyToken.ViewModel>)
}

class CoffeeCardViewController: UIViewController {
    var interactor: CoffeeCardBusinessLogic?
    var router: CoffeeCardRoutingLogic?
    var viewModel: CoffeeCard.FetchProducts.ViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    fileprivate lazy var activityIndicator: FDCActivityIndicator = {
        let view = FDCActivityIndicator()
        return view
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Color.background
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        return collectionView
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
        let interactor = CoffeeCardInteractor()
        let presenter = CoffeeCardPresenter()
        let router = CoffeeCardRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Coffee Card"
        view.backgroundColor = Color.background
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.viewWillAppear()
    }
    
    private func configureViews() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.bringSubviewToFront(activityIndicator)
    }
}

extension CoffeeCardViewController: CoffeeCardDisplayLogic {
    func issueTicketsStateDidChanged(to state: State<CoffeeCard.IssueTickets.ViewModel>) {
        switch state {
        case .loading:
            self.activityIndicator.start()
        case .loaded(_):
            self.activityIndicator.stop()
            showSuccessMessage(message: "You successfully issued a product", actionTitle: "Ok", didPressAction: nil)
        case .error(let error):
            self.activityIndicator.stop()
            showErrorMessage(message: "\(error)", actionTitle: "Ok", didPressAction: nil)
        default:
            break
        }
    }
    
    func fetchProductsStateDidChanged(to state: State<CoffeeCard.FetchProducts.ViewModel>) {
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
    
    func fetchTokenStateDidChanged(to state: State<CoffeeCard.FetchToken.ViewModel>) {
        switch state {
        case .loading:
            self.activityIndicator.start()
        case .loaded(_):
            self.activityIndicator.stop()
        case .error(let error):
            self.activityIndicator.stop()
            showErrorMessage(message: "\(error)", actionTitle: "Ok", didPressAction: nil)
        default:
            break
        }
    }
    
    func verifyTokenStateDidChanged(to state: State<CoffeeCard.VerifyToken.ViewModel>) {
        switch state {
        case .loading:
            self.activityIndicator.start()
        case .loaded(_):
            self.activityIndicator.stop()
            interactor?.tokenIsValid()
        case .error(_):
            self.activityIndicator.stop()
            interactor?.tokenIsInvalid()
        default:
            break
        }
    }
}

extension CoffeeCardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell, let productId = cell.getProductId(), let productName = cell.getName() else { return }
        showInputBox(
            message: "Please ask the customer for his/her customer ID. It can be found on the Profile page in the Café Analog App",
            title: productName,
            actionTitle: "Submit",
            placeholder1: "Barista Initials",
            placeholder2: "Enter customer ID",
            type1: .alphabet,
            type2: .numberPad,
            didPressAction: { initials, customerId in
                let request = CoffeeCard.IssueTickets.Request(productId: productId, customerId: customerId, initials: initials)
                self.interactor?.issueTickets(request: request)
            }
        )
    }
}

extension CoffeeCardViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.cellConfigs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
        let config = viewModel.cellConfigs[indexPath.row]
        cell.configure(config: config)
        return cell
    }
}

extension CoffeeCardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Margin.small, left: Margin.small, bottom: Margin.small, right: Margin.small)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width-Margin.small*2, height: collectionView.bounds.height*0.3)
    }
}
