//
//  guideView.swift
//  Loop Arranger
//
//  Created by Malone, Andrew P. on 2/1/15.
//  Copyright (c) 2015 Andrew Malone. All rights reserved.
//

import UIKit

class guideView: UIView {

    var isActive = false
    let activeColor = UIColor.redColor()
    let inactiveColor = UIColor.whiteColor()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = inactiveColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = inactiveColor
    }
    
    func activate() {
        isActive = true
        self.backgroundColor = activeColor
    }
    
    func deactivate() {
        isActive = false
        self.backgroundColor = inactiveColor
    }

}
