//
//  audioSegment.swift
//  Loop Arranger
//
//  Created by Malone, Andrew P. on 2/2/15.
//  Copyright (c) 2015 Andrew Malone. All rights reserved.
//

import AVFoundation

class AudioSegment {
    var audioFile: AVAudioFile!
    var startFrame: AVAudioFramePosition!
    var frameCount: AVAudioFrameCount!
    
    init(file:AVAudioFile, startPercentage:Float32, lengthPercentage:Float32) {
        audioFile = file
        
        let length = file.length
        startFrame = Int64(Float32(file.length) * startPercentage)
        frameCount = UInt32(Float32(file.length) * lengthPercentage)
        // println("length: \(length), \(startPercentage) -> \(lengthPercentage): \(startFrame) -> \(frameCount)")
    }
}
