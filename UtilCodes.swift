



import SpriteKit
import AVFoundation


var ZERO_ANCHOR = CGPointMake(0.0,0.0)
var gravity: CGFloat = ScreenSize.height/333
var ORIGINAL_GRAVITY = ScreenSize.height/333

//var TIME_PER_FRAME: NSTimeInterval = 0.025
var TIME_PER_FRAME: NSTimeInterval = 0.025*3
var ORIGINAL_TIME_PER_FRAME: NSTimeInterval = 0.025
var GAMESPEED = ScreenSize.width/150
var MAXSPEED = ScreenSize.width/80
var ORIGINAL_GAMESPEED = ScreenSize.width/150

var TOP_LAYER : CGFloat = 100
var MIDDLE_LAYER : CGFloat = 0
var BOTTOM_LAYER : CGFloat = -100

var screenshot : UIImage!


var bgMusicPlayer : AVAudioPlayer!

func playbg(music: String)
{
    let bgMusicUrl = NSBundle.mainBundle().URLForResource(music, withExtension: "mp3")
    bgMusicPlayer = try? AVAudioPlayer(contentsOfURL: bgMusicUrl!)
    bgMusicPlayer.volume = 1
    bgMusicPlayer.numberOfLoops = -1
    bgMusicPlayer.prepareToPlay()
    bgMusicPlayer.play()
}

func StopBgMusic()
{
    bgMusicPlayer.stop()
}

func Scale(node: SKSpriteNode, Height: CGFloat)
{
    let Scale1 = node.size.width/node.size.height
    node.size.height = Height
    node.size.width = node.size.height*Scale1
}

func ScaleWithWidth(node: SKSpriteNode, width: CGFloat)
{
    let Scale1 = node.size.height/node.size.width
    node.size.width = width
    node.size.height = node.size.width*Scale1
}

func animateNode(node: SKSpriteNode)
{
    let down = SKAction.scaleTo(0.9, duration: 0.1)
    let up = SKAction.scaleTo(1.0, duration: 0.1)
    let action = SKAction.sequence([down,up,SKAction.playSoundFileNamed("click.mp3", waitForCompletion: false)])
    node.runAction(action)
}


func forEverAnimation(node: SKSpriteNode,sheet: String,nx: CGFloat,ny: CGFloat,count: Int)
{
    var atlasArray: [SKTexture] = []
    for i in Int(ny-1).stride(to: -1, by: -1)
    {
        for j in 0...Int(nx-1)
        {
            let texture = SKTexture(rect: CGRectMake(CGFloat(j)/nx,CGFloat(i)/ny,CGFloat(1)/nx,CGFloat(1)/ny), inTexture: SKTexture(imageNamed: sheet))
            atlasArray.append(texture)
            if(atlasArray.count == count)
            {
                break;
            }
        }
    }
    let Anime = SKAction.animateWithTextures(atlasArray, timePerFrame: TIME_PER_FRAME)
    node.runAction(SKAction.repeatActionForever(Anime))
}

func animation(node: SKSpriteNode,sheet: String,nx: CGFloat,ny: CGFloat,count: Int)
{
    var atlasArray: [SKTexture] = []
    for i in Int(ny-1).stride(to: -1, by: -1)
    {
        for j in 0...Int(nx-1)
        {
            let texture = SKTexture(rect: CGRectMake(CGFloat(j)/nx,CGFloat(i)/ny,CGFloat(1)/nx,CGFloat(1)/ny), inTexture: SKTexture(imageNamed: sheet))
            atlasArray.append(texture)
            if(atlasArray.count == count)
            {
                break;
            }
        }
    }
    let Anime = SKAction.animateWithTextures(atlasArray, timePerFrame: TIME_PER_FRAME)
    node.runAction(Anime)
}


func SoloAnime(node: SKSpriteNode,textureNamed: String,number: Int,tpf: NSTimeInterval)
{
    let Atlas = SKTextureAtlas(named: textureNamed)
    var atlasArray: [SKTexture] = []
    
    for i in 1...number
    {
        atlasArray.append(Atlas.textureNamed("\(textureNamed)\(i).png"))
    }
    
    let Anime = SKAction.animateWithTextures(atlasArray, timePerFrame: tpf)
    
    node.runAction(Anime)
}

func deanime(node: SKSpriteNode,textureNamed: String,number: Int,tpf: NSTimeInterval)
{
    let Atlas = SKTextureAtlas(named: textureNamed)
    var atlasArray: [SKTexture] = []
    
    for i in 1...number
    {
        atlasArray.append(Atlas.textureNamed("\(textureNamed)\(i).png"))
    }
    
    let Anime = SKAction.animateWithTextures(atlasArray, timePerFrame: tpf)
    
    node.runAction(SKAction.repeatActionForever(Anime))
}


func random(start: CGFloat, end: CGFloat) -> CGFloat
{
    let range = UInt32(start)...UInt32(end)
    return CGFloat(range.startIndex + arc4random_uniform(range.endIndex - range.startIndex + 1))
}

func setAnchors(array : [SKSpriteNode],anchor: CGPoint)
{
    for node in array
    {
        node.anchorPoint = anchor
    }
}


func RandBool() -> Bool
{
    let rand = arc4random_uniform(100)
    
    if(rand%2==0)
    {
        return true
    }
    return false
}

func pickRand(choses: [String]) -> String
{
    let rand = Int(arc4random_uniform(UInt32(choses.count)))
    return choses[rand]
}

func RandFloat(choses: [CGFloat]) -> CGFloat
{
    let rand = CGFloat(arc4random_uniform(UInt32(choses.count)))
    return rand
}


func  initLabel(label: SKLabelNode,text: String,TextColor: UIColor,parent: SKSpriteNode)
{
    label.text = text
    label.fontName = "AvenirNext-Bold"
    label.fontColor = TextColor
    parent.addChild(label)
    label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
    label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
}

func updateText(label: SKLabelNode, Text: String)
{
    let hide = SKAction.scaleTo(0.0, duration: 0.2)
    label.runAction(hide)
    label.text = Text
    let show = SKAction.scaleTo(1.5, duration: 0.2)
    let show2 = SKAction.scaleTo(1.0, duration: 0.2)
    let trans = SKAction.fadeAlphaTo(1.0, duration: 0.2)
    let action = SKAction.sequence([show,show2,trans])
    label.runAction(action)
}

func collision(A : SKSpriteNode, B : SKSpriteNode) -> Bool
{
    if(A.position.x > B.position.x && A.position.x < B.position.x + B.size.width )
    {
        if(A.position.y > B.position.y && A.position.y < B.position.y + B.size.height)
        {
            return true
        }
    }
    return false
}


func RunActionOn(array : [SKSpriteNode], action : SKAction)
{
    for element in array
    {
        element.runAction(action)
    }
}

func AddElementToScene(array: [SKSpriteNode], to: SKScene)
{
    for element in array
    {
        to.addChild(element)
    }
}







































