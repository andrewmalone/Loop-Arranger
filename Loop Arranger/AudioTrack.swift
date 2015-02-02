//
//  AudioTrack.swift
//  Loop Arranger
//
//  Created by Malone, Andrew P. on 2/2/15.
//  Copyright (c) 2015 Andrew Malone. All rights reserved.
//

import AVFoundation

class AudioTrack {
    private var segments = Array<AudioSegment>()
    private var currentPlayingSegment: Int!
    private var player: AVAudioPlayerNode!
    
    init(player: AVAudioPlayerNode) {
        self.player = player
    }
    
    func play() {
        player.play()
        currentPlayingSegment = 0
        scheduleSegment(segments[currentPlayingSegment])
    }
    
    private func scheduleSegment(segment:AudioSegment) {
        player.scheduleSegment(segment.audioFile, startingFrame: segment.startFrame, frameCount: segment.frameCount, atTime: nil, completionHandler: scheduleNext)
    }
    
    private func scheduleNext() {
        if currentPlayingSegment == segments.count - 1 {
            // don't do anything for now
            return
        }
        
        currentPlayingSegment! += 1
        scheduleSegment(segments[currentPlayingSegment])
    }
    
    func addSegment(segment:AudioSegment) {
        segments.append(segment)
    }
}
