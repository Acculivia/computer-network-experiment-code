//
//  GameScene.swift
//  ALOHA
//
//  Created by AlterTaceo on 16/6/8.
//  Copyright (c) 2016年 test. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let addStation = SKLabelNode(text: "Add Station")
    let reset = SKLabelNode(text: "Reset")
    
    var left:CGFloat = 0
    var right:CGFloat = 0
    var up:CGFloat = 0
    var down:CGFloat = 0
    
    var stationAmount = 0
    var hasSignalsSend = 0
    
    var count = 0
    var calculate:CGFloat = 0
    var calculateDuration:CGFloat = 60
    
    var currentSendingPercentage = SKShapeNode()
    
    var stations = [(node: SKShapeNode, station:AStation)]()
    
    override func didMoveToView(view: SKView) {
        
        addStation.position = CGPointMake(200, 100)
        addStation.name = "Control"
        addStation.fontSize = 50
        addStation.verticalAlignmentMode = .Center
        self.addChild(addStation)
        
        reset.position = CGPointMake(size.width - 200, 100)
        reset.name = "Control"
        reset.fontSize = 50
        reset.verticalAlignmentMode = .Center
        self.addChild(reset)
        
        left = 20
        right = size.width - 20
        up = size.height - 20
        down = 200
        
        let line = SKShapeNode(rectOfSize: CGSizeMake(size.width, 20))
        line.position = CGPointMake(size.width / 2, down)
        line.fillColor = UIColor.whiteColor()
        self.addChild(line)
        
        currentSendingPercentage = SKShapeNode(rectOfSize: CGSizeMake(size.width, 20))
        currentSendingPercentage.position = CGPointMake(size.width / 2, down)
        currentSendingPercentage.fillColor = UIColor.yellowColor()
        currentSendingPercentage.alpha = 0.7
        self.addChild(currentSendingPercentage)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        let node = nodeAtPoint(location)
        if(node.name != nil){
            if(node.name == "Control"){controlAccortingToNode(node as! SKLabelNode)}
        }else{
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        let split = (right - left) / CGFloat(stationAmount)
        var sendingStation:Int? = nil
        
        hasSignalsSend = 0
        
        for i in 0..<stationAmount{
            stations[i].station.update()
            let s = CGFloat(stations[i].station.count) / CGFloat(AStation.resendTimeInterval)
            stations[i].node.position.x = split * CGFloat(i) + left
            stations[i].node.position.y = s * (up - down) + down
            
            if(stations[i].station.count == 0){
                hasSignalsSend = hasSignalsSend + 1
                sendingStation = i
            }
        }
        
        if(sendingStation != nil){
            if(hasSignalsSend > 1){
                for station in stations{
                    station.station.resend()
                    station.node.fillColor = UIColor.redColor()
                }
                hasSignalsSend = 0
            }else{
                stations[sendingStation!].station.nextFrame()
                stations[sendingStation!].node.fillColor = UIColor.greenColor()
            }
        }
        
        calculate = calculate + CGFloat(hasSignalsSend) / calculateDuration
        
        if(count == 0){
            currentSendingPercentage.position.y = (up - down) * calculate + down
            calculate = 0
            count = Int(calculateDuration)
        }
        count -= 1
    }
    
    func controlAccortingToNode(node: SKLabelNode){
        switch(node){
            
        case addStation:
            let node = SKShapeNode(circleOfRadius: 20)
            node.fillColor = UIColor.whiteColor()
            node.alpha = 0.5
            self.addChild(node)
            stations.append((node:node, station:AStation()))
            stationAmount = stationAmount + 1
            
        case reset:
            for station in stations{
                station.node.removeFromParent()
            }
            stations = []
            stationAmount = 0
            
        default:
            break
        }
    }
}
