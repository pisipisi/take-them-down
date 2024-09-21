//
//  Menu.swift
//  Canon Hero
//
//  Created by KHALID on 17/09/15.
//  Copyright (c) 2015 KHALID. All rights reserved.
//

import Foundation
import SpriteKit



class Menu
{
    var leader : SKSpriteNode
    var rate : SKSpriteNode
    var shop : SKSpriteNode
    var music : SKSpriteNode!
    var sound : SKSpriteNode!
    var logo : SKSpriteNode
    
    init(parent: SKScene)
    {
        leader = SKSpriteNode(imageNamed: "Leader")
        rate = SKSpriteNode(imageNamed: "Rate")
        shop = SKSpriteNode(imageNamed: "Shop")
        logo = SKSpriteNode(imageNamed: "Logo")
        MusicSoundBtns()
        
        let btnScale = ScreenSize.width/8
        Scale(leader, Height: btnScale)
        Scale(rate, Height: btnScale)
        Scale(shop, Height: btnScale)
        Scale(music, Height: btnScale)
        Scale(sound, Height: btnScale)
        ScaleWithWidth(logo, width: ScreenSize.width*0.7)
        
        let Ypos = ScreenSize.height*0.1
        
        logo.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height*0.6)
        logo.zPosition = BackgroundManager.Layer3 + 100
        shop.position = CGPoint(x: ScreenSize.width/2, y: Ypos)
        // RIGHT
        music.position = CGPoint(x: shop.position.x + music.size.width*1.3, y: Ypos)
        sound.position = CGPoint(x: music.position.x + sound.size.width*1.3 , y: Ypos)
        // LEFT
        rate.position = CGPoint(x: shop.position.x - rate.size.width*1.3 , y: Ypos)
        leader.position = CGPoint(x: rate.position.x - leader.size.width*1.3, y: Ypos)
        
        AddElementToScene([logo,shop,music,sound,rate,leader], to: parent)
    }
    
    func hide()
    {
        let move = SKAction.moveByX(-ScreenSize.width, y: 0, duration: 0.5)
        let hide = SKAction.fadeAlphaTo(0, duration: 0.3)
        let action = SKAction.group([move,hide])
        
        leader.runAction(action)
        rate.runAction(action)
        shop.runAction(action)
        music.runAction(action)
        logo.runAction(hide)
        
        sound.runAction(action, completion: {
            GameScene.GameStarted = true
        })
    }
    
    func MusicSoundBtns()
    {
        if SoundState
        {
            sound = SKSpriteNode(imageNamed: "Sound_On")
        }
        else
        {
            sound = SKSpriteNode(imageNamed: "Sound_Off")
        }
        if MusicState
        {
            music = SKSpriteNode(imageNamed: "Music_On")
        }
        else
        {
            music = SKSpriteNode(imageNamed: "Sound_Off")
        }
    }
    
    func switchSound()
    {
        if SoundState
        {
            animation(sound, sheet: "Sound_Off", nx: 1, ny: 1, count: 1)
            TurnSoundOff()
            SoundState = SoundIsActivated()
        }
        else
        {
            animation(sound, sheet: "Sound_On", nx: 1, ny: 1, count: 1)
            TurnSoundOn()
            SoundState = SoundIsActivated()
        }
    }
    
  
    func switchMusic()
    {
        if MusicState
        {
            StopBgMusic()
            animation(music, sheet: "Sound_Off", nx: 1, ny: 1, count: 1)
            TurnMusicOff()
            MusicState = MusicIsActivated()
        }
        else
        {
            playbg("BgMusic")
            animation(music, sheet: "Music_On", nx: 1, ny: 1, count: 1)
            TurnMusicOn()
            MusicState = MusicIsActivated()
        }
    }
    
}














