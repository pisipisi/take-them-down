//
//  Store.swift
//  Take Them Down
//
//  Created by Pisi on 11/13/15.
//  Copyright © 2015 AznSoft. All rights reserved.
//



import SpriteKit


class Store : SKScene
{
    //var CHARACTER_PRICE = 100
    var Character_Price = [0,100,500,1000]
    var Characters = ["Hero1","Hero2","Hero3","Hero4"]
    var buttons = [SKSpriteNode]()
    var locks = [SKSpriteNode]()
    var holder : SKSpriteNode!
    var header : SKSpriteNode!
    var backBtn : SKSpriteNode!
    var selectBtn : SKSpriteNode!
    var scoreBoard : ScoreManager!
    var selectHero : Int = 0
    var char : SKSpriteNode!
    var head : SKSpriteNode = SKSpriteNode(imageNamed: "Hero1[Head]")
    var legs : SKSpriteNode = SKSpriteNode(imageNamed: "Hero1[Legs]")
    var arm : SKSpriteNode = SKSpriteNode(imageNamed: "Hero1[Arm]")
    
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
        
        let bottom = SKSpriteNode(imageNamed: "bottom_bg")
        bottom.size = CGSize(width: ScreenSize.width, height: ScreenSize.height*0.7)
        bottom.anchorPoint = ZERO_ANCHOR
        self.addChild(bottom)
        
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
        
        for i in 0...1
        {
            let l1 = SKSpriteNode(imageNamed: "bg1")
            ScaleWithWidth(l1, width: ScreenSize.width)
            l1.position = CGPoint(x: CGFloat(i)*ScreenSize.width, y: ScreenSize.height*0.7)
            l1.zPosition = bg.zPosition + 1
            l1.anchorPoint = ZERO_ANCHOR
            self.addChild(l1)
        
            let platfrm = SKSpriteNode(imageNamed: "Platform")
            ScaleWithWidth(platfrm, width: ScreenSize.width)
            platfrm.position = CGPoint(x: CGFloat(i)*ScreenSize.width, y: ScreenSize.height*0.7 - platfrm.size.height)
            platfrm.zPosition = l1.zPosition
            platfrm.anchorPoint = ZERO_ANCHOR
            self.addChild(platfrm)
        }

        selectBtn = SKSpriteNode(imageNamed: "select_btn")
        ScaleWithWidth(selectBtn, width: ScreenSize.width/2)
        selectBtn.position = CGPoint(x: ScreenSize.width/2 - selectBtn.size.width/2, y: ScreenSize.height*0.1)
        selectBtn.zPosition = bg.zPosition + 2
        selectBtn.anchorPoint = ZERO_ANCHOR
        self.addChild(selectBtn)
        
        initCheckBtn()
        setUpButtons()
        initHero(getDefaultCharacter())
        scoreBoard = ScoreManager(parent: self)
        scoreBoard.CHolder.zPosition = BackgroundManager.Layer3 + 100
        scoreBoard.Coins.zPosition = BackgroundManager.Layer3 + 100
        scoreBoard.hideScore()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let touchpos = touch.locationInNode(self)
        if(nodeAtPoint(touchpos) == selectBtn) {
            animateNode(selectBtn)
            if(CheckCharacter(Characters[selectHero]))
            {
                setDefaultCharacter(Characters[selectHero])
                Back()
                return
            } else {
                if(getCoins() >= Character_Price[selectHero])
                {
                    unlockCharacter(Characters[selectHero])
                    setDefaultCharacter(Characters[selectHero])
                    let coins = getCoins() - Character_Price[selectHero]
                    saveCoins(coins)
                    check(buttons[selectHero])
                    showSelectBtn()
                    buttons[selectHero].alpha = 1
                    locks[selectHero].alpha = 0
                } else {
                    scoreBoard.ShackCoins()
                }
                return
            }
        }
        
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
                    selectHero = i
                    animateNode(buttons[i])
                    check(buttons[i])
                    if(CheckCharacter(Characters[i]))
                    {
                        check.alpha = 1
                        changeHero(Characters[i])
                        showSelectBtn()
                        return
                    }
                    else
                    {
                        check.alpha = 0
                        showPriceBtn(Characters[i])
                        changeHero(Characters[i])
                        return
                    }

                }
            }
        }
    }
    
    func setUpButtons()
    {
      //  let btnSize = CGSize(width: holder.size.width/4.1, height: holder.size.height/CGFloat(Characters.count))
        
        var column:Int = 0
        var row:Int = 2
        for i in 0...Characters.count-1
        {
            let btn = SKSpriteNode(imageNamed: Characters[i])
            ScaleWithWidth(btn, width: holder.size.width/CGFloat(4))
            btn.anchorPoint = ZERO_ANCHOR
            btn.position = pointForColumn(column, row: row)
            
            let lock = SKSpriteNode(imageNamed: "locked_check")
            ScaleWithWidth(lock, width: btn.size.width/5)
            lock.anchorPoint = ZERO_ANCHOR
            lock.position = CGPoint(x: btn.position.x + btn.size.width*0.8, y: btn.position.y)
            lock.zPosition = btn.zPosition + 1

            if(CheckCharacter(Characters[i]))
            {
                btn.alpha = 1
                lock.alpha = 0
               
            } else {
            //    let black = SKAction.colorizeWithColor(UIColor.grayColor(), colorBlendFactor: 0.5, duration: 0.0)
            //    btn.runAction(black)
                btn.alpha = 0.5
                lock.alpha = 1
            }
            
            if column == 3 {
                column = 0
                row++
            } else {
                column++
            }
            buttons.append(btn)
            locks.append(lock)
            holder.addChild(btn)
            holder.addChild(lock)
        }
        self.addChild(holder)
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        let eachSpot = ScreenSize.width/CGFloat(4)
        return CGPoint(
            x: CGFloat(column)*eachSpot ,
            y: CGFloat(row)*eachSpot )
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
    
    func initHero(choseHero: String)
    {
    //    let bullet = SKSpriteNode(imageNamed: "\(choseHero)[Bullet]")
        let char = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: 0, height: ScreenSize.height*0.3))

        
        setAnchors([char,legs], anchor: ZERO_ANCHOR)
        arm.anchorPoint = CGPoint(x: 0.3, y: 0.5)
        Scale(head, Height: ScreenSize.height*0.12)
        ScaleWithWidth(legs, width: head.size.width*0.6)
        Scale(arm, Height: ScreenSize.height*0.07)
        
        head.position = CGPoint(x: legs.size.width/2, y: legs.size.height + head.size.height*0.4)
        arm.position = CGPoint(x: head.size.width*0.3, y: head.position.y - head.size.height/2 + arm.size.height/2)
        
        char.addChild(arm)
        char.addChild(legs)
        char.addChild(head)
        char.position = CGPoint(x: ScreenSize.width/3, y: ScreenSize.height*0.7)
        char.zPosition = BackgroundManager.Layer3 + 2
        
        self.addChild(char)
    }
    
    func changeHero(choseHero:String)
    {
        head.texture = SKTexture(imageNamed: "\(choseHero)[Head]")
        legs.texture = SKTexture(imageNamed: "\(choseHero)[Legs]")
        arm.texture = SKTexture(imageNamed: "\(choseHero)[Arm]")
    }
    
    func showPriceBtn(selectedHero:String) {
        selectBtn.texture = SKTexture(imageNamed: "\(selectedHero)[Price_btn]")
    }
    
    func showSelectBtn() {
        selectBtn.texture = SKTexture(imageNamed: "select_btn")
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






















