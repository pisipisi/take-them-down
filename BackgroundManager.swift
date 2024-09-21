//
//  BackgroundManager.swift
//  Canon Hero
//
//  Created by KHALID on 13/09/15.
//  Copyright (c) 2015 KHALID. All rights reserved.
//

import SpriteKit

class BackgroundManager
{
    
    static var Layer1 : CGFloat = -10
    static var Layer2 : CGFloat = 0
    static var Layer3 : CGFloat = 10
    
    var Layer1Array : [SKSpriteNode]
    var Layer2Array : [SKSpriteNode]
    
    var parent : SKScene
    
    var clouds  : [Cloud]
    
    
    init(parent: SKScene)
    {
        
        self.parent = parent
        Layer1Array = [SKSpriteNode]()
        Layer2Array = [SKSpriteNode]()
        clouds = [Cloud]()
        
        setUpSky(parent)
        
        for i in 0...2
        {
            let l1 = SKSpriteNode(imageNamed: "BgLayer1")
            ScaleWithWidth(l1, width: ScreenSize.width)
            l1.position = CGPoint(x: CGFloat(i)*ScreenSize.width, y: Hero.HeroPositionOnScreen.y)
            l1.zPosition = BackgroundManager.Layer1
            
            l1.anchorPoint = ZERO_ANCHOR
            Layer1Array.append(l1)
            
            parent.addChild(l1)
            
            let l2 = SKSpriteNode(imageNamed: "BgLayer2")
            ScaleWithWidth(l2, width: ScreenSize.width)
            l2.position = CGPoint(x: CGFloat(i)*ScreenSize.width, y: Hero.HeroPositionOnScreen.y)
            l2.zPosition = BackgroundManager.Layer2
            
            l2.anchorPoint = ZERO_ANCHOR
            Layer2Array.append(l2)
            
            parent.addChild(l2)
        }
    }
    
    func setUpSky(parent : SKScene)
    {
        let sky = SKSpriteNode(imageNamed: "Sky")
        sky.anchorPoint = ZERO_ANCHOR
        sky.size = ScreenSize
        sky.zPosition = BackgroundManager.Layer1 - 1.0
        parent.addChild(sky)
    }
    
    func move()
    {
        let wait = SKAction.waitForDuration(TowerManager.LevelStepDelay)
        let Layer1move = SKAction.moveByX(-ScreenSize.width/6, y: 0, duration: 0.5)
        let Layer2move = SKAction.moveByX(-ScreenSize.width/4, y: 0, duration: 0.5)
        
        let action1 = SKAction.sequence([wait,Layer1move])
        let action2 = SKAction.sequence([wait,Layer2move])
        
        for p in Layer1Array
        {
            p.runAction(action1, completion: {
                if(p.position.x <= -p.size.width)
                {
                    p.position.x = ScreenSize.width*2
                }
            })
        }
        
        for p in Layer2Array
        {
            p.runAction(action2, completion: {
                if(p.position.x <= -p.size.width)
                {
                    p.position.x = ScreenSize.width*2
                }
            })
        }
    }
    
    
    func genCloud()
    {
        let cloud = Cloud(imgNamed: "Cloud")
        cloud.node.zPosition = BackgroundManager.Layer1 + 1
        self.clouds.append(cloud)
        parent.addChild(cloud.node)
    }
    
    func moveClouds()
    {
        for c in clouds
        {
            c.move()
        }
    }
    
}







