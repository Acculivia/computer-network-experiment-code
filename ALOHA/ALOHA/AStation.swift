//
//  AStation.swift
//  ALOHA
//
//  Created by AlterTaceo on 16/6/8.
//  Copyright © 2016年 test. All rights reserved.
//

import Foundation

class AStation{

    static var nextFrameInterval = 50
    static var resendTimeInterval = 100
    
    var count = 0
    
    func update(){
        if(count > 0){count -= 1}
    }
    
    func nextFrame(){
        count = AStation.nextFrameInterval
    }
    
    func resend(){
        count = Int(arc4random()) % AStation.resendTimeInterval
    }
}