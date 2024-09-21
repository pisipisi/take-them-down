//
//  GameOverMenu.swift
//  Take Them Down
//
//  Created by Pisi on 11/13/15.
//  Copyright © 2015 AznSoft. All rights reserved.
//

import Foundation
import SpriteKit


class GameOverMenu
{
    var home : SKSpriteNode
    var shop : SKSpriteNode
    var replay : SKSpriteNode
    var share : SKSpriteNode
    var rate : SKSpriteNode
    var scoreHoler : SKSpriteNode
    var score : SKLabelNode
    var best : SKLabelNode
    
    var gameover : SKSpriteNode
    
    var revive : SKSpriteNode!
//    var removeAdsBtn: SKSpriteNode!
    var parent : SKScene
    
    init(parent: SKScene, ScoreHolderNamed : String)
    {
        
        GameScene.GameStarted = false
        
        self.parent = parent
        home = SKSpriteNode(imageNamed: "Home")
        shop = SKSpriteNode(imageNamed: "Shop")
        replay = SKSpriteNode(imageNamed: "Replay")
        share = SKSpriteNode(imageNamed: "Share")
        rate = SKSpriteNode(imageNamed: "Rate")
        revive = SKSpriteNode(imageNamed: "Revive")
        
        scoreHoler = SKSpriteNode(imageNamed: ScoreHolderNamed)
        ScaleWithWidth(scoreHoler, width: ScreenSize.width)
        scoreHoler.anchorPoint = ZERO_ANCHOR
        scoreHoler.position.y = ScreenSize.height*1.5
        scoreHoler.zPosition = BackgroundManager.Layer3 + 100
        
        score = SKLabelNode()
        best = SKLabelNode()
        score.fontSize = scoreHoler.size.height/4
        best.fontSize = score.fontSize/2
        score.fontName = "AvenirNext-Bold"
        best.fontName = "AvenirNext-Bold"
        score.text = "\(GameScene.currentScore)"
        best.text = "Best: \(getScore())"
        
        score.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Baseline
        score.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        score.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Baseline
        score.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        score.position = CGPoint(x: ScreenSize.width/2, y: scoreHoler.size.height*0.6)
        best.position = CGPoint(x: ScreenSize.width/2, y: scoreHoler.size.height*0.3)
        scoreHoler.addChild(score)
        scoreHoler.addChild(best)
        
        
        gameover = SKSpriteNode(imageNamed: "Gameover")
        Scale(gameover, Height: (ScreenSize.height/2)-scoreHoler.size.height)
        gameover.position = CGPoint(x: ScreenSize.width/2, y: scoreHoler.position.y + scoreHoler.size.height + gameover.size.height/2)
        
        
        let btnScale = ScreenSize.width/8
        Scale(home, Height: btnScale)
        Scale(shop, Height: btnScale)
        Scale(replay, Height: btnScale*1.5)
        Scale(share, Height: btnScale)
        Scale(rate, Height: btnScale)
        ScaleWithWidth(revive, width: ScreenSize.width*0.35)
        
        let Ypos = ScreenSize.height*1.12
        
        replay.position = CGPoint(x: ScreenSize.width/2, y: Ypos)
        // RIGHT
        share.position = CGPoint(x: replay.position.x + share.size.width*1.3, y: Ypos)
        rate.position = CGPoint(x: share.position.x + rate.size.width*1.3 , y: Ypos)
        // LEFT
        shop.position = CGPoint(x: replay.position.x - shop.size.width*1.3 , y: Ypos)
        home.position = CGPoint(x: shop.position.x - home.size.width*1.3, y: Ypos)
        
        revive.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height*1.5 - revive.size.height/2)
        revive.zPosition = BackgroundManager.Layer3 + 100
        AddElementToScene([shop,rate,home,replay,share,scoreHoler,gameover, revive], to: parent)
        RunActionOn([shop,rate,home,replay,share,scoreHoler,gameover, revive], action: SKAction.moveBy(CGVector(dx: 0, dy: -ScreenSize.height), duration: 0.3))
        
    }
    
    
    func SetReviveBtn()
    {
        revive = SKSpriteNode(imageNamed: "Revive")
        ScaleWithWidth(revive, width: ScreenSize.width*0.35)
        revive.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height/2 - revive.size.height/2)
        revive.zPosition = BackgroundManager.Layer3 + 100
        parent.addChild(revive)
    }
    
/*    func SetRemoveAdsBtn()
    {
        removeAdsBtn = SKSpriteNode(imageNamed: "RemoveAds")
        ScaleWithWidth(removeAdsBtn, width: ScreenSize.width*0.35)
        removeAdsBtn.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height/3 - removeAdsBtn.size.height/2)
        removeAdsBtn.zPosition = BackgroundManager.Layer3 + 100
        parent.addChild(removeAdsBtn)
    }
  */  
    func hide()
    {
        let action = SKAction.moveBy(CGVector(dx: 0, dy: ScreenSize.height), duration: 0)
        RunActionOn([shop,rate,home,replay,share,scoreHoler,gameover,revive], action: action)
    }
    
}












