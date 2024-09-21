//
//  ScoreManager.swift
//  Canon Hero
//
//  Created by KHALID on 15/09/15.
//  Copyright (c) 2015 KHALID. All rights reserved.
//

import Foundation
import SpriteKit


class ScoreManager
{
    var ScoreHolder: SKSpriteNode!
    var Score: SKLabelNode!
    var CoinsHolder: SKSpriteNode!
    var Coins: SKLabelNode!
    
    var SHolder : SKSpriteNode!
    var CHolder : SKSpriteNode!
    
    var parent : SKScene
    
    init(parent: SKScene)
    {
        self.parent = parent
        ScoreHolder =  SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: ScreenSize.width, height: ScreenSize.height/20))
        //        var bg = SKSpriteNode(color: UIColor.blackColor(), size: ScoreHolder.size)
        //        bg.runAction(SKAction.fadeAlphaTo(0.3, duration: 0.0))
        //        ScoreHolder.addChild(bg)
        ScoreHolder.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height-(ScoreHolder.size.height/2))
        setHolders()
        
        Score = SKLabelNode()
        Score.fontSize = SHolder.size.height/4
        initLabel(Score, text: "0",TextColor: UIColor.whiteColor(), parent: SHolder)
        
        Coins = SKLabelNode()
        Coins.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        Coins.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        Coins.fontSize = Score.fontSize
        Coins.position = CGPoint(x: (ScreenSize.width/2)*3/4, y: 0.0)
        initLabel(Coins, text: "\(GameScene.CurrentCoins)",TextColor: UIColor.whiteColor(), parent: ScoreHolder)
        
        ScoreHolder.zPosition = BackgroundManager.Layer1 + 2
        self.parent.addChild(ScoreHolder)
    }
    
    func updateScore(score: Int)
    {
        Score.text = "\(score)"
    }
    
    func UpdateCoins(coins: Int)
    {
        Coins.text = "\(coins)"
        saveCoins(coins)
    }
    
    func hideScore()
    {
       SHolder.runAction(SKAction.fadeAlphaTo(0, duration: 0.3))
    }
    
    func setCoinIcon()
    {
        let Icon = SKSpriteNode(imageNamed: "Coin")
        let Scale = Icon.size.width/Icon.size.height
        Icon.size.height = ScoreHolder.size.height/2
        Icon.size.width = Icon.size.height*Scale
        Icon.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        Icon.position.x = ScreenSize.width/2
        ScoreHolder.addChild(Icon)
    }
    
    func setHolders()
    {
        CHolder = SKSpriteNode(imageNamed: "CoinsHolder")
        Scale(CHolder, Height: ScoreHolder.size.height*1.5)
        CHolder.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        CHolder.position.x = (ScreenSize.width/2)//-(CHolder.size.width*1.5/2)
        ScoreHolder.addChild(CHolder)
        
        SHolder = SKSpriteNode(imageNamed: "ScoreHolder")
        Scale(SHolder, Height: ScoreHolder.size.height*3)
        SHolder.position.y = -ScreenSize.height*0.15
        ScoreHolder.addChild(SHolder)
    }
    
    func ShackCoins()
    {
        let red = SKAction.runBlock({self.Coins.fontColor = UIColor.redColor()})
        let wait = SKAction.waitForDuration(0.2)
        let normal = SKAction.runBlock({self.Coins.fontColor = UIColor.whiteColor()})
        let action = SKAction.repeatAction(SKAction.sequence([red,wait,normal]), count: 4)
        self.Coins.runAction(action)
    }
}


















