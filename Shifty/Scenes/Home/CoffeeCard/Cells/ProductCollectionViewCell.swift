//
//  ProductCollectionViewCell.swift
//  Shifty
//
//  Created by Frederik Christensen on 26/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import UIKit

public class ProductCollectionViewCell: UICollectionViewCell {
    public static let reuseIdentifier: String = "productCell"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.minimumScaleFactor = 0.1
        return label
    }()
    
    private var id: Int?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }
    
    public func configure(config: ProductCellConfig) {
        label.text = config.name
        id = config.id
    }
    
    public func getName() -> String? {
        return label.text
    }
    
    public func getProductId() -> Int? {
        return id
    }
}

public struct ProductCellConfig {
    let name: String
    let id: Int
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
}
