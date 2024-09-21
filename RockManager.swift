//
//  EnimiesManager.swift
//  Take Them Down
//
//  Created by Pisi on 11/13/15.
//  Copyright © 2015 AznSoft. All rights reserved.
//

import Foundation
import SpriteKit



class RockManager
{
    
    static var LevelStepDelay = 0.5
    var canPlay = true
    var rocks : [SKSpriteNode]
    var enemies : [EnemyGuy]
    var parent : SKScene
    
    var maxHeight = ScreenSize.height*0.4
    var minHeight = ScreenSize.height*0.05
    
    init(parent : SKScene)
    {
        self.parent = parent
        rocks = [SKSpriteNode]()
        enemies = [EnemyGuy]()
    }
    
    func createFirst()
    {
        let floating = SKSpriteNode(imageNamed: "floatingisland")
        ScaleWithWidth(floating, width: ScreenSize.width/12)
        let rock = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: floating.size.width, height: floating.size.height))
       
        setAnchors([floating,rock], anchor: ZERO_ANCHOR)
        rock.position = CGPoint(x: random(ScreenSize.width*1.6, end: ScreenSize.width*1.85), y : Hero.HeroPositionOnScreen.y + random(minHeight, end: maxHeight))
        let enemy = EnemyGuy()
        enemy.AddToRock(self.parent, position: CGPoint(x: rock.position.x + rock.size.width/2,
                         y: rock.position.y + rock.size.height + enemy.holder.size.height*0.5))
        enemies.append(enemy)
        rock.addChild(floating)
        parent.addChild(rock)
        
        rocks.append(rock)
        
        let wait = SKAction.waitForDuration(RockManager.LevelStepDelay)
        let show = SKAction.moveByX(-ScreenSize.width, y: 0, duration: RockManager.LevelStepDelay)
        let action = SKAction.sequence([wait,show])
        rock.runAction(action)
        enemy.holder.runAction(action)
        enemy.fly()
    }
    
    func createNew()
    {
        canPlay = false
        createFirst()

        let wait = SKAction.waitForDuration(RockManager.LevelStepDelay)
        let hide = SKAction.moveToX(-rocks[0].size.width, duration: RockManager.LevelStepDelay)
        let action = SKAction.sequence([wait,hide])
        rocks[0].runAction(action, completion: {
            self.rocks[0].removeFromParent()
            self.rocks.removeAtIndex(0)
            self.enemies.removeAtIndex(0)
            self.canPlay = true
        })
    }
    
    func shackRock()
    {
        let right = SKAction.moveToX(rocks.last!.position.x + rocks.last!.size.width * 0.01, duration: 0.1)
        let left = SKAction.moveToX(rocks.last!.position.x - rocks.last!.size.width * 0.01, duration: 0.1)
        let action = SKAction.repeatAction(SKAction.sequence([right,left]), count: 5)
        
        if SoundState
        {
            rocks.last!.runAction(SKAction.group([action,SKAction.playSoundFileNamed("\(getDefaultCharacter())[wall_hited].mp3", waitForCompletion: false)]))
        }
    }
    
    func particles(position: CGPoint)
    {
        for _ in 1...10
        {
            let node = SKSpriteNode(imageNamed: "BulletParticle")
            ScaleWithWidth(node, width: rocks.last!.size.width/5)
            node.position = position
            node.runAction(SKAction.colorizeWithColor(UIColor.blackColor(), colorBlendFactor: random(1, end: 5)/10, duration: 0.0))
            let move = SKAction.moveBy(CGVector(dx: random(0, end: ScreenSize.width/2)-ScreenSize.width/4, dy: random(0.0, end: ScreenSize.height/2)-ScreenSize.height/4), duration: 1)
            let scaledown = SKAction.scaleTo(0.0, duration: NSTimeInterval(random(1, end: 5))/10)
            let remove = SKAction.removeFromParent()
            let group = SKAction.group([move,scaledown])
            let sequence = SKAction.sequence([group,remove])
            parent.addChild(node)
            node.runAction(sequence)
        }
    }
    
    func fireParticles(position: CGPoint) {
        for _ in 1...10
        {
            let node = SKSpriteNode(imageNamed: "BulletParticle")
            ScaleWithWidth(node, width: rocks.last!.size.width/5)
            node.position = position
            node.runAction(SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: random(1, end: 5)/5, duration: 0.0))
            let move = SKAction.moveBy(CGVector(dx: random(0, end: ScreenSize.width/10)-ScreenSize.width/20, dy: random(0.0, end: ScreenSize.height/10)-ScreenSize.height/20), duration: 0.2)
            let moveUp = SKAction.moveBy(CGVector(dx: 0, dy: random(0.0, end: ScreenSize.height/5)), duration: 1)
            //      let moveUp = SKAction.moveToY(random(0.0, end: ScreenSize.height)+ScreenSize.height/2, duration: 1)
            let fireMove = SKAction.sequence([move,moveUp])
            let scale = SKAction.scaleXTo(0, duration: NSTimeInterval(random(1, end: 5)/10))
            let group = SKAction.group([fireMove, scale])
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([group, remove])
            parent.addChild(node)
            node.runAction(sequence)
        }
    }

}












