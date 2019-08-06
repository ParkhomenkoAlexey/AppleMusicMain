//
//  CMTime + Entension.swift
//  Apple Music Swiftbook
//
//  Created by Алексей Пархоменко on 06/08/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let second = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeFormatString = String(format: "%02d:%02d", minutes, second)
        return timeFormatString
    }
    
}
