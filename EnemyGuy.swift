//
//  EnimieGuy.swift
//  Canon Hero
//
//  Created by KHALID on 14/09/15.
//  Copyright (c) 2015 KHALID. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyGuy
{
    var body : SKSpriteNode
    var holder : SKSpriteNode
    var arm : SKSpriteNode
    var bullet : SKSpriteNode!
    var parent : SKScene!
    var isShooting = false
    
    init()
    {
        holder = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: 0, height: Hero.HeroHeight*1.2))
        body = SKSpriteNode(imageNamed: "Enemy")
        arm = SKSpriteNode(imageNamed: "Enemy[Arm]")
        
//        setAnchors([body], ZERO_ANCHOR)
        
        Scale(body, Height: holder.size.height)
        holder.size.width = body.size.width
        ScaleWithWidth(arm, width: body.size.width*1.4)
        
        arm.position = CGPoint(x: 0, y: body.size.height*0.5 - holder.size.height/2)
        holder.zPosition = BackgroundManager.Layer3 + 2
        
        holder.addChild(arm)
        holder.addChild(body)
        
        Idle()
    }
    
    func genCoin()
    {
        let coin = SKSpriteNode(imageNamed: "CoinBonus")
        ScaleWithWidth(coin, width: holder.size.width*2)
        coin.position = CGPoint(x: holder.position.x + holder.size.width/2, y: holder.position.y + holder.size.height/2)
        self.parent.addChild(coin)
        
        let move = SKAction.moveBy(CGVector(dx: 0, dy: holder.size.height*4), duration: 0.7)
        let hide = SKAction.fadeAlphaTo(0, duration: 0.7)
        let action = SKAction.group([move,hide])
        coin.runAction(action, completion: {
            coin.removeFromParent()
        })
        if !SoundState{return}
        holder.runAction(SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false))
    }
    
    func AddToTower(parent: SKScene, position : CGPoint)
    {
        self.parent = parent
        holder.position = position
        holder.zPosition = parent.zPosition + 1
        parent.addChild(holder)
    }
    
    func particles()
    {
        for _ in 1...10
        {
            let node = SKSpriteNode(imageNamed: "BulletParticle")
            ScaleWithWidth(node, width: holder.size.width/2)
            node.position = CGPoint(x: holder.position.x, y: holder.position.y-holder.size.height/2)
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
    
    func Idle()
    {
        let up = SKAction.moveToY(arm.position.y - arm.size.height*0.15, duration: 0.3)
        let down = SKAction.moveToY(arm.position.y + arm.size.height*0.15, duration: 0.3)
        let action = SKAction.sequence([up,down])
        let Idle = SKAction.repeatActionForever(action)
        arm.runAction(Idle)
    }
    
    func die()
    {
        body.runAction(SKAction.colorizeWithColor(UIColor.blackColor(), colorBlendFactor: 1, duration: 0.0))
        let up = SKAction.moveTo(CGPoint(x: holder.position.x + holder.size.width*(random(1, end: 10)/10), y: holder.position.y + holder.size.height), duration: 0.1)
        let down = SKAction.moveTo(CGPoint(x: holder.position.x - holder.size.width/2, y: -holder.size.height*2), duration: 1)
        let hide = SKAction.fadeAlphaTo(0, duration: 0.2)
        let s1 = SKAction.sequence([up,down])
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI)*(random(1,end: 30)/10) , duration: 1)
        let groupAction = SKAction.group([s1,rotate])
        let s2 = SKAction.sequence([groupAction,hide])
        holder.runAction(s2)
        if !SoundState{return}
        holder.runAction(SKAction.playSoundFileNamed("player_die.mp3", waitForCompletion: false))
    }
    
    
    func initBullet(targetPosition : CGPoint)
    {
        bullet = SKSpriteNode(imageNamed: "bullet")
        Scale(bullet, Height: arm.size.height*0.7)
        bullet.size.width = -bullet.size.width
        bullet.position = CGPoint(x: holder.position.x , y: holder.position.y + arm.position.y)
        bullet.zPosition = BackgroundManager.Layer3 + 1
        arm.zPosition = BackgroundManager.Layer3 + 2
        body.zPosition = BackgroundManager.Layer3 + 3
        parent.addChild(bullet)
        
        let dx = Double(holder.position.x - targetPosition.x)
        let dy = Double(holder.position.y - targetPosition.y)
        
        let angle = atan(dy/dx)
        
        self.bullet.runAction(SKAction.rotateToAngle(CGFloat(angle), duration: 0.5))
        arm.runAction(SKAction.rotateToAngle(CGFloat(angle), duration: 0.5), completion :{
            self.isShooting = true
            self.shackArm()
        })
    }
    
    func blowBullet(position : CGPoint)
    {
        for _ in 1...10
        {
            let particle = SKSpriteNode(imageNamed: "BlowParticle")
            particle.position = position
            particle.zPosition = BackgroundManager.Layer3 + 3
            ScaleWithWidth(particle, width: ScreenSize.width/10)
            let scaleup = SKAction.scaleTo(random(1, end: 5)/5, duration: 0.2)
            let hide = SKAction.fadeAlphaTo(0, duration: 0.2)
            let remove = SKAction.removeFromParent()
            let group = SKAction.group([scaleup,hide])
            let action = SKAction.sequence([group,remove])
            parent.addChild(particle)
            particle.runAction(action)
        }
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
    
    func bulletParticles() // Path
    {
        let node = SKSpriteNode(imageNamed: "BulletParticle")
        Scale(node, Height: self.bullet.size.height*0.8)
        node.position = CGPoint(x: self.bullet.position.x , y: self.bullet.position.y)
        node.zPosition = BackgroundManager.Layer3 + 1
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
    
    
    func BulletCollision(target : SKSpriteNode) -> Bool
    {
        if(bullet.position.x < target.position.x)
        {
            bulletHit(bullet.position)
            return true
        }
        return false
    }
    
    func shoot()
    {
        isShooting = true
        if(bullet.position.x - bullet.size.width/2 < ScreenSize.width && bullet.position.y - bullet.size.height/2 < ScreenSize.height)
        {
            bulletParticles()
            bullet.position.x += -cos(bullet.zRotation)*ScreenSize.width/30
            bullet.position.y += -sin(bullet.zRotation)*ScreenSize.width/30
        }
    }
}

































