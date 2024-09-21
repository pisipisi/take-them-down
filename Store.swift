//
//  Store.swift
//  Canon Hero
//
//  Created by KHALID on 17/09/15.
//  Copyright (c) 2015 KHALID. All rights reserved.
//

//
//  Store.swift
//  Super spring jumper
//
//  Created by KHALID on 17/09/15.
//  Copyright (c) 2015 KHALID. All rights reserved.
//




import SpriteKit


class Store : SKScene
{
    var CHARACTER_PRICE = 10
    var Characters = ["Hero3","Hero2","Hero1"]
    var buttons = [SKSpriteNode]()
    
    var holder : SKSpriteNode!
    var header : SKSpriteNode!
    var backBtn : SKSpriteNode!
    
    var scoreBoard : ScoreManager!
    
    var check : SKSpriteNode!
    
    override init(size: CGSize) {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        GameViewController.HideAds()
        
        let bg = SKSpriteNode(imageNamed: "Sky")
        bg.size = ScreenSize
        bg.anchorPoint = ZERO_ANCHOR
        self.addChild(bg)
        
        holder = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: ScreenSize.width, height: ScreenSize.height*0.8))
        holder.anchorPoint = ZERO_ANCHOR
        
        header = SKSpriteNode(imageNamed: "ShopHeader")
        Scale(header, Height: ScreenSize.height*0.1)
        header.anchorPoint = ZERO_ANCHOR
        header.position = CGPoint(x: ScreenSize.width/2 - header.size.width/2, y: ScreenSize.height - header.size.height)
       
        
        backBtn = SKSpriteNode(imageNamed: "BackBtn")
        Scale(backBtn, Height: ScreenSize.height*0.1)
        backBtn.anchorPoint = ZERO_ANCHOR
        backBtn.position = CGPoint(x: backBtn.size.width * 0.2, y: ScreenSize.height - backBtn.size.height)
        
        self.addChild(backBtn)
        self.addChild(header)
        
        initCheckBtn()
        setUpButtons()
        
        scoreBoard = ScoreManager(parent: self)
        scoreBoard.CHolder.zPosition = BackgroundManager.Layer3 + 100
        scoreBoard.Coins.zPosition = BackgroundManager.Layer3 + 100
        scoreBoard.hideScore()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let touchpos = touch.locationInNode(self)
        
        
        if(nodeAtPoint(touchpos) == backBtn)
        {
            animateNode(backBtn)
            timer("Back", after: 0.5)
        }
        else
        {
            for i in 0...buttons.count-1
            {
                if(nodeAtPoint(touchpos) == buttons[i])
                {
                    animateNode(buttons[i])
                    if(CheckCharacter(Characters[i]))
                    {
                        check(buttons[i])
                        setDefaultCharacter(Characters[i])
                        return
                    }
                    else
                    {
                        if(getCoins() >= CHARACTER_PRICE)
                        {
                            unlockCaracter(Characters[i])
                            setDefaultCharacter(Characters[i])
                            let coins = getCoins() - CHARACTER_PRICE
                            saveCoins(coins)
                            check(buttons[i])
                            Back()
                        }
                        else
                        {
                            scoreBoard.ShackCoins()
                        }
                        return
                    }
                }
            }
        }
    }
    
    func setUpButtons()
    {
        let btnSize = CGSize(width: holder.size.width*0.95, height: holder.size.height/CGFloat(Characters.count))
        
        for i in 0...Characters.count-1
        {
            
            var imageNamed = "Locked"
            
            if(CheckCharacter(Characters[i]))
            {
                imageNamed = Characters[i]
            }
            
            let btn = SKSpriteNode(imageNamed: imageNamed)
            btn.size = btnSize
            btn.anchorPoint = ZERO_ANCHOR
            btn.position = CGPoint(x: ScreenSize.width/2 - btn.size.width/2, y: btn.size.height * CGFloat(i))
            
            buttons.append(btn)
            holder.addChild(btn)
        }
        self.addChild(holder)
    }
    
    
    func initCheckBtn()
    {
        check = SKSpriteNode(imageNamed: "Check")
        check.anchorPoint = ZERO_ANCHOR
        check.zPosition = BackgroundManager.Layer2
        holder.addChild(check)
    }
    
    func check(target: SKSpriteNode)
    {
        ScaleWithWidth(check, width: target.size.width)
        check.position = target.position
        check.zPosition = target.zPosition + 10.0
    }
    
    
    func Back()
    {
        let scene = GameScene(size: ScreenSize)
        scene.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        let SKview = self.view as SKView?
        SKview?.presentScene(scene)
    }
    
    func timer(method: String, after: NSTimeInterval)
    {
        _ = NSTimer.scheduledTimerWithTimeInterval(after, target: self, selector: Selector(method), userInfo: nil, repeats: false)
    }
}






















