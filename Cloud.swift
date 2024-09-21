//
//  Cloud.swift
//  Canon Hero
//
//  Created by KHALID on 15/09/15.
//  Copyright (c) 2015 KHALID. All rights reserved.
//

import Foundation
import SpriteKit


class Cloud
{
    var node : SKSpriteNode
    var speed: CGFloat
    static var delay : Int = 120
    
    init(imgNamed : String)
    {
        self.node = SKSpriteNode(imageNamed: imgNamed)
        ScaleWithWidth(node, width: random(ScreenSize.width*0.1, end: ScreenSize.width*0.25))
        node.anchorPoint = ZERO_ANCHOR
        node.position = CGPoint(x: ScreenSize.width, y: random(ScreenSize.height*0.6, end: ScreenSize.height))
        node.runAction(SKAction.fadeAlphaTo(random(4, end: 10)/10, duration: 0.0))
        speed = random(ScreenSize.width/300, end: ScreenSize.width/300)
    }
    
    func move()
    {
        node.position.x -= speed
    }
    
}