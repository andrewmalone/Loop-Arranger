//
//  ViewController.swift
//  Loop Arranger
//
//  Created by Malone, Andrew P. on 2/1/15.
//  Copyright (c) 2015 Andrew Malone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainGuide: guideView!
    @IBOutlet weak var guideLeft: NSLayoutConstraint!
    @IBOutlet weak var guideWidth: NSLayoutConstraint!
    
    var ghostImage: UIImageView!
    var ghostImageIsIntersectingGuide = false
    
    var guides = Array<guideView>()
    var segmentsInTrack = Array<UIImageView>()
    var guideRects = Array<CGRect>()
    var guideHits = Array<UIView>()
    
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
                if CGRectIntersectsRect(ghostImage.frame, mainGuide.frame) {
                    mainGuide.activate()
                    ghostImageIsIntersectingGuide = true
                }
            }
            else {
                // remove highlight if needed
                if !CGRectIntersectsRect(ghostImage.frame, mainGuide.frame) {
                    mainGuide.deactivate()
                    ghostImageIsIntersectingGuide = false
                }
            }
            
        case .Ended:
            // drop in place if needed
            if ghostImageIsIntersectingGuide {
                addSegmentToEndOfTrack()
            }
            else if let index = getIndexOfActiveGuide() {
                addSegmentBeforeSegmentAtIndex(index + 1)
                guides[index].deactivate()
            }
            else {
                ghostImage.removeFromSuperview()
                ghostImage = nil
            }
            
        default:
            break
        }
    }
    
    @IBAction func reset() {
        // reset the track back to initial state...
        
        // remove guides, segments, and hit tracking rects
        for guide in guides {
            guide.removeFromSuperview()
        }
        guides = []
        
        for segment in segmentsInTrack {
            segment.removeFromSuperview()
        }
        segmentsInTrack = []
        
        guideRects = []
        drawGuideRects()
        
        // reset the main guide position
        guideLeft.constant = 0
        
    }
    
    func getIndexOfActiveGuide() -> Int? {
        for (index, guide) in enumerate(guides) {
            if guide.isActive {
                return index
            }
        }
        return nil
    }
    
    func addSegmentToEndOfTrack() {
        ghostImage.center = mainGuide.center
        ghostImage.alpha = 1
        
        segmentsInTrack.append(ghostImage)
        
        if segmentsInTrack.count > 1 {
            addGuideBeforeSegmentAtIndex(segmentsInTrack.count - 1)
        }
        
        guideLeft.constant += mainGuide.frame.width + 8
        mainGuide.deactivate()
    }
    
    func addSegmentBeforeSegmentAtIndex(index:Int) {
        // position the ghost image
        ghostImage.center.x = segmentsInTrack[index].center.x - (segmentsInTrack[index].bounds.width/2) + (ghostImage.bounds.width/2)
        ghostImage.center.y = mainGuide.center.y
        ghostImage.alpha = 1
        
        
        let offset = ghostImage.bounds.width + 8
        
        // move everything over...
        for i in index..<segmentsInTrack.count {
            // move the segments
            segmentsInTrack[i].center.x += offset
            
            if i != segmentsInTrack.count - 1 {
                //move the guides
                guides[i].center.x += offset
                guideRects[i] = CGRectOffset(guideRects[i], offset, 0)
            }
        }
        guideLeft.constant += offset
        // adjust the guideRect before the inserted segment
        let r = guideRects[index - 1]
        guideRects[index - 1] = CGRectMake(
            CGRectGetMinX(r),
            CGRectGetMinY(r),
            ghostImage.center.x - segmentsInTrack[index - 1].center.x,
            r.height)
        
        segmentsInTrack.insert(ghostImage, atIndex: index)
        
        addGuideBeforeSegmentAtIndex(index + 1)
    }
    
    func addGuideBeforeSegmentAtIndex(index:Int) {
        let rect1 = segmentsInTrack[index - 1] // segment before the new guide
        let rect2 = segmentsInTrack[index] // segment after the new guide
        
        var newGuide = guideView(frame: CGRect(
            x: CGRectGetMinX(rect2.frame) - 6,
            y: CGRectGetMinY(rect2.frame),
            width: 4,
            height: rect2.frame.height))
        
        view.addSubview(newGuide)
        guides.insert(newGuide, atIndex: index - 1)
        
        let guide = CGRect(
            x: rect1.center.x,
            y: CGRectGetMinY(rect1.frame),
            width: rect2.center.x - rect1.center.x,
            height: rect1.frame.height)
        
        guideRects.insert(guide, atIndex: index - 1)
        // drawGuideRects()
    }
    
    func drawGuideRects() {
        // for debugging
        
        // clear the rects
        for rect in guideHits {
            rect.removeFromSuperview()
        }
        guideHits = []
        
        // draw the rects
        for rect in guideRects {
            var gv = UIView(frame: rect)
            gv.layer.borderColor = UIColor.blueColor().CGColor
            gv.layer.borderWidth = 1
            view.addSubview(gv)
            guideHits.append(gv)
        }
    }
}

