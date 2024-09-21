//
//  PlatformManager.swift
//  Canon Hero
//
//  Created by KHALID on 13/09/15.
//  Copyright (c) 2015 KHALID. All rights reserved.
//

//
//  Platform.swift
//  Banana Kong
//
//  Created by KHALID on 05/03/15.
//  Copyright (c) 2015 KHALID. All rights reserved.
//

import SpriteKit

class PlatformManager
{
    
    var platformArray : [SKSpriteNode]
    
    
    init(parent: SKScene)
    {
        platformArray = [SKSpriteNode]()
        
        let bottom = SKSpriteNode(imageNamed: "bottom_bg")
        bottom.size = CGSize(width: ScreenSize.width, height: Hero.HeroPositionOnScreen.y)
        bottom.anchorPoint = ZERO_ANCHOR
        parent.addChild(bottom)
        
        for i in 0...1
        {
            let platfrm = SKSpriteNode(imageNamed: "Platform")
            ScaleWithWidth(platfrm, width: ScreenSize.width)
            platfrm.position = CGPoint(x: CGFloat(i)*ScreenSize.width, y: Hero.HeroPositionOnScreen.y - platfrm.size.height)
            
            platfrm.anchorPoint = ZERO_ANCHOR
            platformArray.append(platfrm)
            
            parent.addChild(platfrm)
        }
        
    }
    
    func move()
    {
        let wait = SKAction.waitForDuration(TowerManager.LevelStepDelay)
        let move = SKAction.moveByX(-ScreenSize.width, y: 0, duration: TowerManager.LevelStepDelay)
        let action = SKAction.sequence([wait,move])
        
        for p in platformArray
        {
            p.runAction(action, completion: {
                if(p.position.x < 0)
                {
                    p.position.x = ScreenSize.width
                }
            })
        }
    }
    
}










































