//
//  Hero.swift
//  Take Them Down
//
//  Created by Pisi on 11/13/15.
//  Copyright © 2015 AznSoft. All rights reserved.
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
    var fever : SKSpriteNode
    var parent : SKScene
    var bullet : SKSpriteNode
    var line : SKSpriteNode
    var isShooting = false
    var ShotPower : CGFloat!
    var XSpeed : CGFloat!
    var YSpeed : CGFloat!
    var canPlay = true
    var FeverMode = false
    var animateShield : SKSpriteNode
    
    init(parent : SKScene)
    {
        self.parent = parent
        
        fever = SKSpriteNode(imageNamed: "nofever")
        
        animateShield = SKSpriteNode(imageNamed: "nofever")
        bullet = SKSpriteNode(imageNamed: "\(getDefaultCharacter())[Bullet]")
        holder = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: 0, height: Hero.HeroHeight))
        head = SKSpriteNode(imageNamed: "\(getDefaultCharacter())[Head]")
        legs = SKSpriteNode(imageNamed: "\(getDefaultCharacter())[Legs]")
        arm = SKSpriteNode(imageNamed: "\(getDefaultCharacter())[Arm]")
        line = SKSpriteNode(imageNamed: "line")
        setAnchors([holder,legs], anchor: ZERO_ANCHOR)
        arm.anchorPoint = CGPoint(x: 0.3, y: 0.5)
        
        Scale(head, Height: Hero.HeroHeight*0.7)
        ScaleWithWidth(legs, width: head.size.width*0.7)
        Scale(arm, Height: Hero.HeroHeight*0.5)
        Scale(line, Height: Hero.HeroHeight*2)
        head.position = CGPoint(x: legs.size.width/2, y: legs.size.height + head.size.height*0.4)
        arm.position = CGPoint(x: head.size.width*0.3, y: head.position.y - head.size.height/2 + arm.size.height/2)
        
        
        Scale(animateShield, Height: Hero.HeroHeight*2)
        
        forEverAnimation(animateShield, sheet: "shield", nx: 5, ny: 4, count: 20)

        
        animateShield.position = CGPoint(x: legs.size.width/2, y: legs.position.y + legs.size.height )
        animateShield.alpha = 0
        holder.addChild(fever)
        holder.addChild(arm)
        holder.addChild(legs)
        holder.addChild(head)
        holder.addChild(animateShield)
        holder.position = Hero.HeroPositionOnScreen
        holder.zPosition = BackgroundManager.Layer3 + 2
        fever.removeFromParent()
        self.parent.addChild(holder)
        
        self.Idle()
        
        self.initBullet()
        self.initLine()
    }
    
    func Idle()
    {
        arm.runAction(SKAction.rotateToAngle(0, duration: 0.5))
        line.runAction(SKAction.rotateToAngle(0, duration: 0.5))
        let down = SKAction.moveBy(CGVector(dx: 0, dy: head.size.height/8), duration: 0.4)
        let up = SKAction.moveBy(CGVector(dx: 0, dy: -head.size.height/8), duration: 0.4)
        let action = SKAction.sequence([up,down])
        head.runAction(SKAction.repeatActionForever(action))
        
    }
    
    func initFever() {
        Scale(fever, Height: Hero.HeroHeight*2)
        forEverAnimation(fever, sheet: "fever", nx: 4, ny: 1, count: 4)
        fever.position = CGPoint(x: legs.size.width/2, y: legs.position.y + 3 * legs.size.height )
        holder.addChild(fever)
    }
    
    func initFeverText() {
        let feverText = SKLabelNode()
        feverText.fontSize = ScreenSize.height/20
        feverText.text = "Fever"
        feverText.fontName = "AvenirNext-Bold"
        feverText.color = UIColor.redColor()
        feverText.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height/2)
        let flash = SKAction.sequence([SKAction.fadeInWithDuration(0.3), SKAction.waitForDuration(0.3), SKAction.fadeOutWithDuration(0.3),SKAction.removeFromParent()])
        feverText.runAction(flash)
        parent.addChild(feverText)
    }
    
    func removeFever() {
        fever.removeFromParent()
    }
    
    func move()
    {
        let walk = SKAction.runBlock({forEverAnimation(self.legs, sheet: "\(getDefaultCharacter())[Walk]", nx: 3, ny: 1, count: 3)})
        let wait = SKAction.waitForDuration(RockManager.LevelStepDelay)
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
        arm.runAction(black)

    //    Head blowup
        let headUp = SKAction.moveTo(CGPoint(x: holder.position.x + head.size.width*(random(1, end: 5)), y: holder.position.y + head.size.height*(random(1, end: 5))), duration: 0.1)
        let headDown = SKAction.moveTo(CGPoint(x: holder.position.x + head.size.width*(random(6, end: 10)), y: 0), duration: 1)
        let headHide = SKAction.fadeAlphaTo(0, duration: 0.2)
        let headS1 = SKAction.sequence([headUp,headDown])
        let headRotate = SKAction.rotateByAngle(CGFloat(M_PI)*(random(1,end: 30)) , duration: 1)
        let headGroupAction = SKAction.group([headS1,headRotate])
        let headS2 = SKAction.sequence([headGroupAction,headHide])
        head.runAction(headS2)
        
        // Legs Blow up 
        let legUp = SKAction.moveTo(CGPoint(x: holder.position.x + legs.size.width*(random(1, end: 5)), y: holder.position.y + legs.size.height*(random(1, end: 5))), duration: 0.1)
        let legDown = SKAction.moveTo(CGPoint(x: holder.position.x + legs.size.width*(random(6, end: 10)), y: 0), duration: 1)
        let legHide = SKAction.fadeAlphaTo(0, duration: 0.2)
        let legS1 = SKAction.sequence([legUp,legDown])
        let legRotate = SKAction.rotateByAngle(CGFloat(M_PI)*(random(1,end: 30)) , duration: 1)
        let legGroupAction = SKAction.group([legS1,legRotate])
        let legS2 = SKAction.sequence([legGroupAction,legHide])
        legs.runAction(legS2)
        // Arm Blow
        let armUp = SKAction.moveTo(CGPoint(x: holder.position.x + arm.size.width*(random(1, end: 10)/10), y: holder.position.y + arm.size.height*(random(1, end: 5))), duration: 0.1)
        let armDown = SKAction.moveTo(CGPoint(x: holder.position.x + arm.size.width*(random(11, end: 20)/10), y: 0), duration: 1)
        let armHide = SKAction.fadeAlphaTo(0, duration: 0.2)
        let armS1 = SKAction.sequence([armUp,armDown])
        let armRotate = SKAction.rotateByAngle(CGFloat(M_PI)*(random(1,end: 30)) , duration: 1)
        let armGroupAction = SKAction.group([armS1,armRotate])
        let armS2 = SKAction.sequence([armGroupAction,armHide])
        arm.runAction(armS2)
          //animate quake, shake the scene
        let moveX_1: SKAction = SKAction.moveBy(CGVectorMake(-7, 0), duration: 0.05)
        let moveX_2: SKAction = SKAction.moveBy(CGVectorMake(-10, 0), duration: 0.05)
        let moveX_3: SKAction = SKAction.moveBy(CGVectorMake(7, 0), duration: 0.05)
        let moveX_4: SKAction = SKAction.moveBy(CGVectorMake(10, 0), duration: 0.05)
        let moveY_1: SKAction = SKAction.moveBy(CGVectorMake(-0, -7), duration: 0.05)
        let moveY_2: SKAction = SKAction.moveBy(CGVectorMake(0, -10), duration: 0.05)
        let moveY_3: SKAction = SKAction.moveBy(CGVectorMake(0, 7), duration: 0.05)
        let moveY_4: SKAction = SKAction.moveBy(CGVectorMake(0, 10), duration: 0.05)
        let trembleX: SKAction = SKAction.sequence([moveX_1, moveX_4, moveX_2, moveX_3])
        let trembleY: SKAction = SKAction.sequence([moveY_1, moveY_4, moveY_2, moveY_3])
                
        for child: SKNode in self.parent.children {
            child.runAction(trembleX)
            child.runAction(trembleY)
            }
                
    /*    let splat: SKSpriteNode = SKSpriteNode(imageNamed: "splat.png")
        Scale(splat, Height: self.parent.size.height/2)
        splat.position = CGPointMake(self.parent.frame.size.width / 2, self.parent.frame.size.height / 2)
        splat.zPosition = BackgroundManager.Layer3 + 2
        self.parent.addChild(splat)
        splat.runAction(SKAction.scaleTo(1, duration: 0.1))
     */   
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
        
        showLine()
        head.zRotation = arm.zRotation/2
    }
    
    func initBullet()
    {
        stopBulletFever()
        
        bullet.position = CGPoint(x: holder.position.x + arm.position.x + arm.size.width*0.6, y: holder.position.y + arm.position.y)
        bullet.zPosition = BackgroundManager.Layer3 + 1
        bullet.anchorPoint = CGPoint(x: 1, y: 0.5)
        hideBullet()
        parent.addChild(bullet)
    }
    
    func showBulletFever() {
         Scale(bullet, Height: arm.size.height*1.5)
    }
    
    func stopBulletFever() {
        if (getDefaultCharacter() == "Hero4" || getDefaultCharacter() == "Hero2") {
            Scale(bullet, Height: arm.size.height*0.8)
        } else {
            Scale(bullet, Height: arm.size.height*0.5)
        }
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
        line.runAction(initRotation)
        arm.runAction(initRotation)
        head.runAction(initRotation)
        bullet.runAction(SKAction.fadeAlphaTo(0, duration: 0))
        

    }
    
    func initLine()
    {
        // line
        Scale(line, Height: arm.size.height*4)
        line.position = CGPoint(x: holder.position.x + arm.position.x + arm.size.width, y: holder.position.y + arm.position.y)
        line.zPosition = BackgroundManager.Layer3 + 1
        line.anchorPoint = CGPoint(x: 0.1, y: 0.5)
        hideLine()
        parent.addChild(line)
    }
    
    func hideLine()
    {
        // hide line
        line.position = CGPoint(x: holder.position.x + arm.position.x , y: holder.position.y + arm.position.y)
        let initRotation = SKAction.rotateToAngle(0, duration: 0.3)
     //   bullet.runAction(initRotation)
        line.runAction(initRotation)
       // arm.runAction(initRotation)
     //   head.runAction(initRotation)
        line.runAction(SKAction.fadeAlphaTo(0, duration: 0))
    }
    
    func showLine()
    {
        // show line
    //    line.position = CGPoint(x: holder.position.x + arm.position.x, y: holder.position.y + arm.position.y)
        
        line.runAction(SKAction.fadeAlphaTo(1, duration: 0))
        
        line.zRotation = arm.zRotation
    }
    
    
    func bulletParticles() // PATH
    {
        let node = SKSpriteNode(imageNamed: "\(getDefaultCharacter())[BulletParticle]")
        node.position = CGPoint(x: self.bullet.position.x , y: self.bullet.position.y)
        node.zPosition = self.bullet.zPosition - 1
        self.parent.addChild(node)
        if(getDefaultCharacter() == "Hero2" || getDefaultCharacter() == "Hero4") {
            
            Scale(node, Height: self.bullet.size.height*0.5)
            
            
            let move = SKAction.moveBy(CGVector(dx: random(0, end: ScreenSize.width/2)-ScreenSize.width/4, dy: random(0.0, end: ScreenSize.height/2)-ScreenSize.height/4), duration: 1)
            let scaledown = SKAction.scaleTo(0.0, duration: NSTimeInterval(random(1, end: 5))/10)
            let remove = SKAction.removeFromParent()
            let wait = SKAction.waitForDuration(0.5)
            let group = SKAction.group([move,scaledown])
            node.runAction(SKAction.sequence([group,wait,remove]))
            
        } else {
            Scale(node, Height: self.bullet.size.height*0.8)
            let scaledown = SKAction.scaleTo(0, duration: 0.5)
            let wait = SKAction.waitForDuration(0.5)
            let remove = SKAction.removeFromParent()
            node.runAction(SKAction.sequence([scaledown,wait,remove]))
            
        }

    }
    


    func shackArm()
    {
        let right = SKAction.moveByX(-arm.size.width/10, y: 0, duration: 0.02)
        let left = SKAction.moveByX(arm.size.width/10, y: 0, duration: 0.02)
        let shack = SKAction.sequence([right,left])
        if !SoundState {return}
        arm.runAction(SKAction.group([shack,SKAction.playSoundFileNamed("\(getDefaultCharacter())[shoot].mp3", waitForCompletion: false)]))
    }
    
    func reloadSound()
    {
        if !SoundState {return}
        arm.runAction(SKAction.playSoundFileNamed("\(getDefaultCharacter())[reload].mp3", waitForCompletion: false))
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
            bullet.position.x += cos(bullet.zRotation)*ScreenSize.width/35
            bullet.position.y += sin(bullet.zRotation)*ScreenSize.width/35
            
            if arm.zRotation == CGFloat(M_PI_2){return false}
            
            bullet.zRotation -= bullet.zRotation/80
        }
        else
        {
            return true
            //hideBullet()
        }
        return false
    }
}































