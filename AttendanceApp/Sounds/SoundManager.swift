//
//  SoundManager.swift
//  MyEnvironment
//
//  Created by Marko Dimitrijevic on 31/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import AVFoundation

var soundPlayer: AVAudioPlayer?

func playSound(name: String, ext: String = "mp3") {
    
    guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
        return
    }
    
    do {
        //try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setCategory(.playback)
        try AVAudioSession.sharedInstance().setActive(true)
        
        soundPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        
        guard let player = soundPlayer else { return }
        
        player.play()
        
    } catch let error {
        print(error.localizedDescription)
    }
}
