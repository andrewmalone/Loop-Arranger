//
//  segmentView.swift
//  Loop Arranger
//
//  Created by Malone, Andrew P. on 2/1/15.
//  Copyright (c) 2015 Andrew Malone. All rights reserved.
//

import UIKit

class segmentView: UIView {

    var audioSegment: AudioSegment!
    
    func makeGhost() -> UIImageView {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        self.layer.renderInContext(context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var imgView = UIImageView(image: img)
        imgView.alpha = 0.5
        return imgView
    }

}
