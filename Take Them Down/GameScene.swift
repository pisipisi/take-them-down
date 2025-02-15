//
//  GameScene.swift
//  Canon Hero
//
//  Created by KHALID on 13/09/15.
//  Copyright (c) 2015 KHALID. All rights reserved.
//

import SpriteKit
import Social
import GameKit
import StoreKit

class GameScene: SKScene, ChartboostDelegate, GKGameCenterControllerDelegate {
    
    static var CurrentCoins = 0
    
    var BGM : BackgroundManager!
    var hero : Hero!
    var platform : PlatformManager!
    var levelManager : RockManager!
    var menu : Menu!
    var gameOverMenu : GameOverMenu!
    static var GAMEOVER = false
    static var GameStarted = false
//    static var FeverMode = false
    var scoreBoard : ScoreManager!
    static var currentScore = 0
    static var currentShield = 0
    static var currentHit = 0
    override init(size: CGSize) {
        super.init(size: size)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        if MusicState {playbg("BgMusic")}
        
        // ADS
        GameViewController.HideAds()
        Chartboost.startWithAppId(kChartboostAppID, appSignature: kChartboostAppSignature, delegate: self)
        Chartboost.cacheRewardedVideo(CBLocationDefault)
        
        switch(interstitialType)
        {
        case .Admob :
                initInterstitial()
            break;
        case .Chartboost :
            Chartboost.cacheInterstitial(CBLocationDefault)
            break;
        }
        //*******
        
        GameScene.CurrentCoins = getCoins()
        GameScene.GAMEOVER = false
        
        BGM = BackgroundManager(parent: self)
        
        scoreBoard = ScoreManager(parent: self)
        
        platform = PlatformManager(parent: self)
        
        hero = Hero(parent: self)
        
        menu = Menu(parent: self)
        
        levelManager = RockManager(parent: self)
        levelManager.createFirst()
        BGM.move()
        platform.move()
        hero.move()
        
        if(GameScene.currentScore != 0)
        {
            scoreBoard.updateScore(GameScene.currentScore)
            menu.hide()
        }
    }
    
    var TouchDown = false
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        if(!GameScene.GameStarted && GameScene.GAMEOVER)
        {
            let touch = touches.first! 
            let pos = touch.locationInNode(self)
            
            if(nodeAtPoint(pos) == gameOverMenu.home)
            {
                GameScene.currentScore = 0
                GameScene.currentShield = 0
                hero.animateShield.alpha = 0
                replay()
            }
            else if(nodeAtPoint(pos) == gameOverMenu.replay)
            {
                replay()
            }
            else if(nodeAtPoint(pos) == gameOverMenu.share)
            {
                let alert = UIAlertController(title: "Share", message: "Share Your Score With Friends", preferredStyle: UIAlertControllerStyle.ActionSheet)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in }
                alert.addAction(cancelAction)
                    
                let facebook = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.Default) { action -> Void in self.Facebook() }
                alert.addAction(facebook)
                    
                let twitter = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default) { action -> Void in self.Twitter() }
                alert.addAction(twitter)
                    
                let viewcontroller = UIApplication.sharedApplication().keyWindow!.rootViewController!
                    
                viewcontroller.presentViewController(alert, animated: true, completion: nil)
                
            }
            else if(nodeAtPoint(pos) == gameOverMenu.rate)
            {
                Rate()
            }
            else if(nodeAtPoint(pos) == gameOverMenu.shop)
            {
                StoreScene()
            }
            else if(gameOverMenu.revive != nil)
            {
                if(nodeAtPoint(pos) == gameOverMenu.revive)
                {
                    animateNode(gameOverMenu.revive)
               //     Chartboost.showRewardedVideo(CBLocationDefault)
                    revive(GameScene.currentScore)
                }
            }
            
    /*        if(nodeAtPoint(pos) == gameOverMenu.removeAdsBtn)
            {
                animateNode(gameOverMenu.removeAdsBtn)
                // create the alert
                let alert = UIAlertController(title: "No Ads", message: "Remove all ads from the game for $0.99", preferredStyle: UIAlertControllerStyle.Alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: {action in self.buyProduct()}))
                alert.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.Cancel, handler: nil))
                let viewcontroller = UIApplication.sharedApplication().keyWindow!.rootViewController!
                // show the alert
                viewcontroller.presentViewController(alert, animated: true, completion: nil)
                
            
            } */
        }
        else if !GameScene.GameStarted
        {
            let touch = touches.first! 
            let pos = touch.locationInNode(self)
            
            if(nodeAtPoint(pos) == menu.leader)
            {
               showLeader()
            }
            else if(nodeAtPoint(pos) == menu.shop)
            {
                StoreScene()
            }
            else if(nodeAtPoint(pos) == menu.rate)
            {
                Rate()
            }
            else if(nodeAtPoint(pos) == menu.sound)
            {
                menu.switchSound()
            }
            else if(nodeAtPoint(pos) == menu.music)
            {
                menu.switchMusic()
            }
            else
            {
                menu.hide()
                GameViewController.ShowAds()
            }
        }
        else if(!hero.isShooting && levelManager.canPlay && !GameScene.GAMEOVER && hero.canPlay)
        {
            hero.reloadSound()
            TouchDown = true
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if(!hero.isShooting && levelManager.canPlay && TouchDown && !GameScene.GAMEOVER)
        {
            hero.isShooting = true
            hero.shackArm()
            hero.showBullet()
            hero.hideLine()
            TouchDown = false
            if (hero.FeverMode)
            {
   //             hero.removeFever()
                hero.showBulletFever()
      //          GameScene.FeverMode = false
                
            } else {
                hero.stopBulletFever()
            }
        }
    }
    
    func didDisplayRewardedVideo(location: String!) {
        StopBgMusic()
    }
    
    var currentFrame : Int = 0
    var gameoverCounter = 0
    var gameoverDelay = 120 // 2sec
    
    override func update(currentTime: CFTimeInterval) {

        BGM.moveClouds()
        
        if(currentFrame < Cloud.delay)
        {
            currentFrame++
        }
        else
        {
            currentFrame = 0
            BGM.genCloud()
        }
        
        if levelManager.enemies.last!.isShooting
        {
            levelManager.enemies.last!.shoot()
            if(levelManager.enemies.last!.BulletCollision(hero.holder) && !GameScene.GAMEOVER)
            {   if(GameScene.currentShield == 0) {
                hero.die()
                GameScene.GAMEOVER = true
                if(hero.FeverMode) {
                    hero.removeFever()
                }
            } else {
                GameScene.currentShield--
                levelManager.canPlay = true
                hero.canPlay = true
                hero.isShooting = false
                levelManager.enemies.last!.isShooting = false
                levelManager.enemies.last?.bullet.runAction(SKAction.fadeAlphaTo(0, duration: 0))
                scoreBoard.UpdateShields(GameScene.currentShield)
                if(GameScene.currentShield == 0) {
                    hero.animateShield.alpha = 0
                }
                }
            }
        }
        
        if GameScene.GAMEOVER
        {
            gameoverCounter++
            if(gameoverCounter >= gameoverDelay && GameScene.GameStarted)
            {
                GameScene.GameStarted = false
                scoreBoard.hideScore()
                
                var ScoreHolderNamed = "GameOverScoreHolder"
                
                if(GameScene.currentScore > getScore())
                {
                    saveScore(GameScene.currentScore)
                    ScoreHolderNamed += "Top"
                }
                gameOverMenu = GameOverMenu(parent: self, ScoreHolderNamed : ScoreHolderNamed)
                ShowInterAds()
            //    gameOverMenu.SetReviveBtn()
           //     gameOverMenu.SetRemoveAdsBtn()
           //     if(Chartboost.hasRewardedVideo(CBLocationDefault))
           //     {
            //        gameOverMenu.SetReviveBtn()
            //    }
            }
            return
        }
        
        if(TouchDown)
        {
            hero.prepare()
        }
        else if(hero.isShooting)
        {
            if hero.shoot()
            {
                levelManager.enemies.last!.initBullet(hero.holder.position)
                hero.hideBullet()
            }
            
            if(Collision().isCollided)
            {
                if Collision().isPerfect
                {
                    if (arc4random_uniform(5) == 1) {
                        levelManager.enemies.last!.genShield()
                        GameScene.currentShield++
                        scoreBoard.UpdateShields(GameScene.currentShield)
                        hero.animateShield.alpha = 1
                    } else {
                        if hero.FeverMode {
                            GameScene.CurrentCoins = GameScene.CurrentCoins + Int(arc4random_uniform(5))
                    //        GameScene.currentHit = 0
                     //       GameScene.FeverMode = false
                        } else {
                            GameScene.CurrentCoins++
                            GameScene.currentHit++
                        }
                        levelManager.enemies.last!.genCoin()
                        scoreBoard.UpdateCoins(GameScene.CurrentCoins)
                    }
                    
                } else {
                    GameScene.currentHit = 0
                    if hero.FeverMode {
                        hero.FeverMode = false
                        hero.removeFever()
                    }
                }
                
                if(GameScene.currentHit > 2)
                {
                    GameScene.currentHit = 0
                    hero.initFever()
                    hero.initFeverText()
                    hero.FeverMode = true
                }
                GameScene.currentScore++
                scoreBoard.updateScore(GameScene.currentScore)
                levelManager.enemies.last!.particles()
                hero.bulletHit(CGPoint(x: levelManager.rocks.last!.position.x + levelManager.rocks.last!.size.width/2 , y: hero.bullet.position.y))
                levelManager.enemies.last!.die()
                hero.hideBullet()
                levelManager.createNew()
                hero.move()
                platform.move()
                BGM.move()
            }
            else if(RockCollision().isCollided && !GameScene.GAMEOVER)
            {
                hero.canPlay = false

                if (getDefaultCharacter() == "Hero2" || getDefaultCharacter() == "Hero4") {
                    levelManager.fireParticles(RockCollision().CollisionPoint)
                } else {
                    levelManager.particles(RockCollision().CollisionPoint)
                }
                
                levelManager.shackRock()
                hero.hideBullet()
                levelManager.enemies.last!.initBullet(hero.holder.position)
            }
        }
    }
    
    
    func RockCollision() -> (isCollided: Bool, CollisionPoint: CGPoint)
    {
        var isCollided = false
        var ColPosition = CGPoint(x: 0, y: 0)
        
        if(hero.bullet.position.x > levelManager.rocks.last!.position.x &&
            hero.bullet.position.x < levelManager.rocks.last!.position.x + levelManager.rocks.last!.size.width )
        {
            if(hero.bullet.position.y > levelManager.rocks.last!.position.y &&
                hero.bullet.position.y < levelManager.rocks.last!.position.y + levelManager.rocks.last!.size.height - levelManager.enemies.last!.holder.size.height*0.1)
            {
                isCollided = true
                ColPosition = hero.bullet.position
            }
        }
        return (isCollided,ColPosition)
    }
    
    
    func Collision() -> (isCollided: Bool, isPerfect: Bool)
    {
        var isCol = false
        var isPer = false
        
        if(hero.bullet.position.x > levelManager.enemies.last!.holder.position.x &&
            hero.bullet.position.x < levelManager.enemies.last!.holder.position.x + levelManager.enemies.last!.holder.size.width )
        {
            if(hero.bullet.position.y > levelManager.enemies.last!.holder.position.y -  levelManager.enemies.last!.holder.size.height/2 &&
                hero.bullet.position.y < levelManager.enemies.last!.holder.position.y + levelManager.enemies.last!.holder.size.height*0.8)
            {
                isCol = true
                if(hero.bullet.position.y + hero.bullet.size.height > levelManager.enemies.last!.holder.position.y + levelManager.enemies.last!.holder.size.height/2)
                {
                    isPer = true
                }
            }
        }
        return (isCol,isPer)
    }
    
    func revive(withScore : Int)
    {
        GameScene.currentScore = withScore
        if(getCoins() >= 50)
        {
            let coins = getCoins() - 50
            saveCoins(coins)
            let black = SKSpriteNode(color: UIColor.blackColor(), size: ScreenSize)
            black.anchorPoint = ZERO_ANCHOR
            black.zPosition = BackgroundManager.Layer3 + 100
            black.runAction(SKAction.fadeAlphaTo(0, duration: 0))
            self.addChild(black)
            let show = SKAction.fadeAlphaTo(1, duration: 0.2)
        
            black.runAction(show, completion: {
            
            let scene = GameScene(size: ScreenSize)
            scene.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            let SKview = self.view as SKView?
            SKview?.presentScene(scene)
            
            })
        } else {
            scoreBoard.ShackCoins()
        }

        
    }
    
    
    
    func replay()
    {
        if(GameScene.currentScore > getScore())
        {
            saveScore(GameScene.currentScore)
        }
        
        GameScene.currentScore = 0
        GameScene.currentHit = 0
        hero.FeverMode = false
        
        let black = SKSpriteNode(color: UIColor.blackColor(), size: ScreenSize)
        black.anchorPoint = ZERO_ANCHOR
        black.zPosition = BackgroundManager.Layer3 + 100
        black.runAction(SKAction.fadeAlphaTo(0, duration: 0))
        self.addChild(black)
        let show = SKAction.fadeAlphaTo(1, duration: 0.2)

        black.runAction(show, completion: {
            
            let scene = GameScene(size: ScreenSize)
            scene.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            let SKview = self.view as SKView?
            SKview?.presentScene(scene)
            
        })
    }
    
    func StoreScene()
    {
        if(GameScene.currentScore > getScore())
        {
            saveScore(GameScene.currentScore)
        }
        
        GameScene.currentScore = 0
        GameScene.currentHit = 0
        hero.FeverMode = false
        
        let scene = Store(size: ScreenSize)
        scene.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        let SKview = self.view as SKView?
        SKview?.presentScene(scene)
    }
    
    func Rate()
    {
        UIApplication.sharedApplication().openURL(NSURL(string: ITUNES_LINK)!)
    }
    
    func didCompleteRewardedVideo(location: String!, withReward reward: Int32) {
        
        revive(GameScene.currentScore)
    }
    
    func ShowInterAds()
    {
        if CanShowAds() {
        interCounter()
        // ADS STUFF
        
            if(InterC%TO_SHOW_INTERSTITIAL == 0)
            {
                switch(interstitialType)
                {
                case .Admob :
                    ShowInterstitial(self.view?.window!.rootViewController as UIViewController!)
                    interstitialType = InterstitialType.Chartboost
                
                    break;
                case .Chartboost :
                    Chartboost.showInterstitial(CBLocationDefault)
                    interstitialType = InterstitialType.Admob
                
                    break;
                }
            }
            else if(interstitialType == InterstitialType.Chartboost)
            {
                Chartboost.cacheInterstitial(CBLocationDefault)
            }
        }
        //********
        else {
            GameViewController.HideAds()
        }
    }
    
    func showLeader() {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func Facebook()
    {
        let share: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        share.setInitialText(SHARE_TEXT)
        share.addImage(screenShotMethod())
        let vc = self.view?.window!.rootViewController as UIViewController?
        vc?.presentViewController(share, animated: true, completion: nil)
    }
    
    func Twitter()
    {
        let share: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        share.setInitialText(SHARE_TEXT)
        share.addImage(screenShotMethod())
        let vc = self.view?.window!.rootViewController as UIViewController?
        vc?.presentViewController(share, animated: true, completion: nil)
    }
    
    
    func screenShotMethod() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(UIScreen.mainScreen().bounds.size, false, 0);
        self.view?.drawViewHierarchyInRect(view!.bounds, afterScreenUpdates: true)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }

}




























