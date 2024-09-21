//
//  Settings.swift
//  Take Them Down
//
//  Created by Pisi on 11/13/15.
//  Copyright © 2015 AznSoft. All rights reserved.
//

import Foundation
import GameKit


var LEADERBOARD_ID = "take_score"
var ITUNES_LINK = "https://itunes.apple.com/us/app/take-them-down/id1059083737"
var SHARE_TEXT = "Just Got \(GameScene.currentScore), Download now : \(ITUNES_LINK)"



var SoundState = SoundIsActivated()
var MusicState = MusicIsActivated()

func SoundIsActivated() -> Bool
{
    if let Sound: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("Sound"){
        
        let temp : Bool = Sound as! Bool
        
        return temp
        
    }
    else {
        return true
    }
}

func TurnSoundOff()
{
    NSUserDefaults.standardUserDefaults().setObject(false, forKey:"Sound")
    NSUserDefaults.standardUserDefaults().synchronize()
}

func TurnMusicOff()
{
    NSUserDefaults.standardUserDefaults().setObject(false, forKey:"Music")
    NSUserDefaults.standardUserDefaults().synchronize()
}


func TurnSoundOn()
{
    NSUserDefaults.standardUserDefaults().setObject(true, forKey:"Sound")
    NSUserDefaults.standardUserDefaults().synchronize()
}

func TurnMusicOn()
{
    NSUserDefaults.standardUserDefaults().setObject(true, forKey:"Music")
    NSUserDefaults.standardUserDefaults().synchronize()
}

func MusicIsActivated() -> Bool
{
    if let Music: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("Music"){
        
        let temp : Bool = Music as! Bool
        
        return temp
        
    }
    else {
        return true
    }
}


func saveScore(TopScore: Int)
{
    saveHighscore(TopScore)
    NSUserDefaults.standardUserDefaults().setObject(TopScore, forKey:"TowerScore")
    NSUserDefaults.standardUserDefaults().synchronize()
}


func saveHighscore(score:Int) {
    
    //check if user is signed in
    if GKLocalPlayer.localPlayer().authenticated {
        
        let scoreReporter = GKScore(leaderboardIdentifier: LEADERBOARD_ID) //leaderboard id here
        
        scoreReporter.value = Int64(score) //score variable here (same as above)
        
        let scoreArray: [GKScore] = [scoreReporter]
        
        GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError?) -> Void in
            if error != nil {
                print("error")
            }
        })
        
    }
    
}


func getScore() -> Int
{
    if let highscore: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("TowerScore"){
        
        let temp : Int = highscore as! Int
        
        return temp
        
    }
    else {
        return 0
    }
}

func getCoins() -> Int
{
    if let highscore: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("Coins"){
        
        let temp : Int = highscore as! Int
        
        return temp
        
    }
    else {
        return 0
    }
}

func saveCoins(CurrentCoins : Int)
{
    NSUserDefaults.standardUserDefaults().setObject(CurrentCoins, forKey:"Coins")
    NSUserDefaults.standardUserDefaults().synchronize()
}

func RemoveAds()
{
    NSUserDefaults.standardUserDefaults().setObject(false, forKey:"Ads")
    NSUserDefaults.standardUserDefaults().synchronize()
}

func CanShowAds() -> Bool
{
    if let character: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("Ads"){
        
        let temp : Bool = character as! Bool
        
        return temp
        
    }
    else {
        return true
    }
}


func CheckCharacter(id : String) -> Bool
{
    if let character: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey(id){
        
        let temp : Bool = character as! Bool
        
        return temp
        
    }
    else {
        return false
    }
}
func getDefaultCharacter() -> String
{
    if let character: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("defaultCharacter"){
        
        let temp : String = character as! String
        
        return temp
    }
    else {
        return "Hero1"
    }
}

func getRandomEnemy() -> String
{
    return String(arc4random_uniform(3) + 1)
}

func unlockCharacter(id: String)
{
    NSUserDefaults.standardUserDefaults().setObject(true, forKey:id)
    NSUserDefaults.standardUserDefaults().synchronize()
}


func setDefaultCharacter(id : String)
{
    NSUserDefaults.standardUserDefaults().setObject(id, forKey:"defaultCharacter")
    NSUserDefaults.standardUserDefaults().synchronize()
}

