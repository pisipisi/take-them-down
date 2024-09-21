//
//  Hero.swift
//  Canon Hero
//
//  Created by KHALID on 13/09/15.
//  Copyright (c) 2015 KHALID. All rights reserved.
//

import Foundation
import SpriteKit


class Hero
{

    static var HeroHeight = ScreenSize.height*0.05
    static var HeroPositionOnScreen = CGPoint(x: ScreenSize.width*0.1, y: ScreenSize.height*0.2)
    
    var holder : SKSpriteNode
    var head : SKSpriteNode
    var legs : SKSpriteNode
    var arm : SKSpriteNode
    var parent : SKScene
    var bullet : SKSpriteNode
    var isShooting = false
    var ShotPower : CGFloat!
    var XSpeed : CGFloat!
    var YSpeed : CGFloat!
    var canPlay = true
    
    init(parent : SKScene)
    {
        self.parent = parent
        
        bullet = SKSpriteNode(imageNamed: "\(getDefaultCharacter())[Bullet]")
        holder = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: 0, height: Hero.HeroHeight))
        head = SKSpriteNode(imageNamed: "\(getDefaultCharacter())[Head]")
        legs = SKSpriteNode(imageNamed: "\(getDefaultCharacter())[Legs]")
        arm = SKSpriteNode(imageNamed: "\(getDefaultCharacter())[Arm]")
        
        setAnchors([holder,legs], anchor: ZERO_ANCHOR)
        arm.anchorPoint = CGPoint(x: 0.3, y: 0.5)
        
        Scale(head, Height: Hero.HeroHeight*0.7)
        ScaleWithWidth(legs, width: head.size.width*0.7)
        Scale(arm, Height: Hero.HeroHeight*0.5)
        
        head.position = CGPoint(x: legs.size.width/2, y: legs.size.height + head.size.height*0.4)
        arm.position = CGPoint(x: head.size.width*0.3, y: head.position.y - head.size.height/2 + arm.size.height/2)
        
        
        holder.addChild(arm)
        holder.addChild(legs)
        holder.addChild(head)
        
        holder.position = Hero.HeroPositionOnScreen
        holder.zPosition = BackgroundManager.Layer3 + 2
        
        self.parent.addChild(holder)
        
        Idle()
        
        initBullet()
        
    }
    
    func Idle()
    {
        arm.runAction(SKAction.rotateToAngle(0, duration: 0.5))
        let down = SKAction.moveBy(CGVector(dx: 0, dy: head.size.height/8), duration: 0.4)
        let up = SKAction.moveBy(CGVector(dx: 0, dy: -head.size.height/8), duration: 0.4)
        let action = SKAction.sequence([up,down])
        head.runAction(SKAction.repeatActionForever(action))
    }
    
    func move()
    {
        let walk = SKAction.runBlock({forEverAnimation(self.legs, sheet: "walk", nx: 3, ny: 1, count: 3)})
        let wait = SKAction.waitForDuration(TowerManager.LevelStepDelay)
        let stop = SKAction.runBlock({self.stop()})
        holder.runAction(SKAction.sequence([wait,walk,wait,stop]))
    }
    
    func stop()
    {
        legs.removeAllActions()
        forEverAnimation(legs, sheet: "\(getDefaultCharacter())[Legs]", nx: 1, ny: 1, count: 1)
    }
    
    func die()
    {
        stop()
        head.removeAllActions()
        
        let black = SKAction.colorizeWithColor(UIColor.blackColor(), colorBlendFactor: 1, duration: 0.0)
        head.runAction(black)
        legs.runAction(black)
        let rotate = SKAction.rotateToAngle(CGFloat(M_PI_2) , duration: 0.1)
        let action = SKAction.group([rotate])
        holder.runAction(action)
        arm.runAction(SKAction.rotateToAngle(CGFloat(-M_PI_2), duration: 0.1))
        if !SoundState{return}
        holder.runAction(SKAction.playSoundFileNamed("player_die.mp3", waitForCompletion: false))
    }
    
    func prepare()
    {
        if(arm.zRotation < CGFloat(M_PI_2))
        {
            arm.zRotation += (CGFloat(M_PI)/2)/60
        }
        else
        {
            arm.zRotation = CGFloat(M_PI_2)
        }
        head.zRotation = arm.zRotation/2
    }
    
    func initBullet()
    {
        Scale(bullet, Height: arm.size.height*0.5)
        bullet.position = CGPoint(x: holder.position.x + arm.position.x + arm.size.width*0.6, y: holder.position.y + arm.position.y)
        bullet.zPosition = BackgroundManager.Layer3 + 1
        bullet.anchorPoint = CGPoint(x: 1, y: 0.5)
        hideBullet()
        parent.addChild(bullet)
    }
    
    func showBullet()
    {
        bullet.runAction(SKAction.fadeAlphaTo(1, duration: 0))
        bullet.zRotation = arm.zRotation
    }
    
    func hideBullet()
    {
        isShooting = false
        bullet.position = CGPoint(x: holder.position.x + arm.position.x , y: holder.position.y + arm.position.y)
        let initRotation = SKAction.rotateToAngle(0, duration: 0.3)
        bullet.runAction(initRotation)
        arm.runAction(initRotation)
        head.runAction(initRotation)
        bullet.runAction(SKAction.fadeAlphaTo(0, duration: 0))
    }
    
    func bulletParticles() // PATH
    {
        let node = SKSpriteNode(imageNamed: "BulletParticle")
        Scale(node, Height: self.bullet.size.height*0.8)
        node.position = CGPoint(x: self.bullet.position.x , y: self.bullet.position.y)
        node.zPosition = self.bullet.zPosition - 1
        self.parent.addChild(node)
        let scaledown = SKAction.scaleTo(0, duration: 0.5)
        let wait = SKAction.waitForDuration(0.5)
        let remove = SKAction.removeFromParent()
        node.runAction(SKAction.sequence([scaledown,wait,remove]))
    }
    
    func shackArm()
    {
        let right = SKAction.moveByX(-arm.size.width/10, y: 0, duration: 0.02)
        let left = SKAction.moveByX(arm.size.width/10, y: 0, duration: 0.02)
        let shack = SKAction.sequence([right,left])
        if !SoundState {return}
        arm.runAction(SKAction.group([shack,SKAction.playSoundFileNamed("shoot.mp3", waitForCompletion: false)]))
    }
    
    func reloadSound()
    {
        if !SoundState {return}
        arm.runAction(SKAction.playSoundFileNamed("reload.mp3", waitForCompletion: false))
    }
    
    func bulletHit(position: CGPoint)
    {
        for _ in 1...10
        {
            let node = SKSpriteNode(imageNamed: "BulletParticle")
            ScaleWithWidth(node, width: ScreenSize.width/15)
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
    
    func shoot() -> Bool
    {
        if(bullet.position.x - bullet.size.width/2 < ScreenSize.width && bullet.position.y - bullet.size.height/2 < ScreenSize.height)
        {
            
            bulletParticles()
            bullet.position.x += cos(bullet.zRotation)*ScreenSize.width/40
            bullet.position.y += sin(bullet.zRotation)*ScreenSize.width/40
            
            if arm.zRotation == CGFloat(M_PI_2){return false}
            
            bullet.zRotation -= bullet.zRotation/100
        }
        else
        {
            return true
            //hideBullet()
        }
        return false
    }
}































