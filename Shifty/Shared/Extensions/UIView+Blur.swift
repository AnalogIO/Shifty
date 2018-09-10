//
//  UIView.swift
//  ClipCard
//
//  Created by Frederik Dam Christensen on 14/02/2018.
//  Copyright © 2018 Frederik Dam Christensen. All rights reserved.
//

import UIKit

extension UIView {
    func addBlurEffect(effect style: UIBlurEffectStyle) {
        let blurEffect = UIBlurEffect(style:style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
