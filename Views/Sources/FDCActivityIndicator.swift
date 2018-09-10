//
//  FDCActivityIndicator.swift
//  ClipCard
//
//  Created by Frederik Dam Christensen on 22/02/2018.
//  Copyright © 2018 Frederik Dam Christensen. All rights reserved.
//

import UIKit

public class FDCActivityIndicator: UIView {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        view.color = .black
        view.hidesWhenStopped = true
        view.contentMode = .scaleToFill
        return view
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    public init() {
        super.init(frame: CGRect.zero)

        layer.cornerRadius = 10
        layer.masksToBounds = true
        isHidden = true
        
        addSubview(blurEffectView)
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        activityIndicator.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func start() {
        isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    public func stop() {
        isHidden = true
        self.activityIndicator.stopAnimating()
    }
}
