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
    var player: AVAudioPlayerNode!
    var playing = false
    
    init(player: AVAudioPlayerNode) {
        self.player = player
    }
    
    func play() {
        player.play()
        if segments.count > 0 {
            currentPlayingSegment = 0
            scheduleSegment(segments[currentPlayingSegment])
        }
        playing = true
    }
    
    func stop() {
        player.stop()
        currentPlayingSegment = nil
        playing = false
    }
    
    func reset() {
        if player.playing {
            player.stop()
        }
        segments = []
        currentPlayingSegment = nil
        playing = false
    }
    
    private func scheduleSegment(segment:AudioSegment) {
        // println("schedule \(currentPlayingSegment)")
        player.scheduleSegment(segment.audioFile, startingFrame: segment.startFrame, frameCount: segment.frameCount, atTime: nil, completionHandler: scheduleNext)
    }
    
    private func scheduleNext() {
        if currentPlayingSegment == nil {
            return
        }
        if currentPlayingSegment! == segments.count - 1 {
            currentPlayingSegment = 0
            scheduleSegment(segments[currentPlayingSegment])
            return
        }
        
        currentPlayingSegment! += 1
        scheduleSegment(segments[currentPlayingSegment])
    }
    
    func addSegment(segment:AudioSegment) {
        segments.append(segment)
    }
    
    func insertSegment(segment:AudioSegment, atIndex index:Int) {
        segments.insert(segment, atIndex: index)
        // adjust the current playing index if needed
        
        if currentPlayingSegment! >= index {
            currentPlayingSegment! += 1
        }
    }
}
