//
//  ViewController.swift
//  Loop Arranger
//
//  Created by Malone, Andrew P. on 2/1/15.
//  Copyright (c) 2015 Andrew Malone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var guide: guideView!
    @IBOutlet weak var guideLeft: NSLayoutConstraint!
    @IBOutlet weak var guideWidth: NSLayoutConstraint!
    
    var ghostImage: UIImageView!
    var ghostImageIsIntersectingGuide = false
    
    var guides = Array<guideView>()
    var segmentsInTrack = Array<UIImageView>()
    var guideRects = Array<CGRect>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add gesture recognizers
        let filteredViews = view.subviews.filter({ $0.isKindOfClass(segmentView) } )
        for subView in filteredViews {
            let recognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
            subView.addGestureRecognizer(recognizer)
        }
        
    }
    
    func handlePan(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let currentPoint = sender.locationInView(view)
        let currentCenter = sender.view!.center
        let x = currentCenter.x + translation.x
        let y = currentCenter.y + translation.y
        let center = CGPointMake(x, y)
        
        var triggerView = sender.view! as segmentView
        
        switch sender.state {
        case .Began:
            // create a new ghost image
            ghostImage = triggerView.makeGhost()
            view.addSubview(ghostImage)
            ghostImage.center = center
            
            // set the guide width to match current view
            guideWidth.constant = ghostImage.frame.width
            
        case .Changed:
            ghostImage.center = center
            
            for (index, rect) in enumerate(guideRects) {
                if CGRectContainsPoint(rect, currentPoint) {
                    guides[index].activate()
                }
                else {
                    guides[index].deactivate()
                }
            }
            
            if !ghostImageIsIntersectingGuide && getIndexOfActiveGuide() == nil {
                // check for intersection with the guide
                if CGRectIntersectsRect(ghostImage.frame, guide.frame) {
                    guide.activate()
                    ghostImageIsIntersectingGuide = true
                }
            }
            else {
                // remove highlight if needed
                if !CGRectIntersectsRect(ghostImage.frame, guide.frame) {
                    guide.deactivate()
                    ghostImageIsIntersectingGuide = false
                }
            }
            
        case .Ended:
            // drop in place if needed
            if ghostImageIsIntersectingGuide {
                ghostImage.center = guide.center
                ghostImage.alpha = 1
                
                segmentsInTrack.append(ghostImage)
                
                if segmentsInTrack.count > 1 {
                    var newGuide = guideView(frame: CGRect(
                        x: CGRectGetMinX(ghostImage.frame) - 6,
                        y: CGRectGetMinY(ghostImage.frame),
                        width: 4,
                        height: ghostImage.frame.height))

                    view.addSubview(newGuide)
                    guides.append(newGuide)
                    
                    let rect1 = segmentsInTrack[segmentsInTrack.count - 2]
                    let rect2 = segmentsInTrack[segmentsInTrack.count - 1]
                    let guide = CGRect(
                        x: rect1.center.x,
                        y: CGRectGetMinY(rect1.frame),
                        width: rect2.center.x - rect1.center.x,
                        height: rect1.frame.height)
                    
                    guideRects.append(guide)
                }
                
                guideLeft.constant += guide.frame.width + 8
                guide.deactivate()
                
            }
            else {
                ghostImage.removeFromSuperview()
                ghostImage = nil
            }
            
        default:
            break
        }
    }
    
    func getIndexOfActiveGuide() -> Int? {
        for (index, guide) in enumerate(guides) {
            if guide.isActive {
                return index
            }
        }
        
        return nil
    }
}

