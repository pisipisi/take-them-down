//
//  Monitisation.swift
//  Take Them Down
//
//  Created by Pisi on 11/13/15.
//  Copyright © 2015 AznSoft. All rights reserved.
//

import GoogleMobileAds

var TO_SHOW_INTERSTITIAL = 3 // NUMBER OF GAMEOVER TO SHOW INTERSTITAL

var interstitialType = InterstitialType.Admob// CHANGE TO InterstitialType.Admob TO SHOW ADMOB INTERSTITIAL
let kChartboostAppID = "56469c81a8b63c6e8abca63b" // Chartboost APP ID
let kChartboostAppSignature = "0fbd803ec95c3c4b07f7a25980da15d118de555f" // Chartboost App Signature

var INTERSTITIAL_ID = "ca-app-pub-5660577648479236/3561665338" // ADMOB INTERSTITAL ID ca-app-pub-9501203044398619/6802870682
var BannerID = "ca-app-pub-9501203044398619/6802870682" // ADMOB BANNER ID


var isInitialized = false
var InterC : Int = 0
func interCounter()
{
    if(InterC<=TO_SHOW_INTERSTITIAL)
    {
        InterC++
        if(InterC>TO_SHOW_INTERSTITIAL)
        {
            InterC = 0
            initInterstitial()
        }
    }
}

var interstitial = GADInterstitial(adUnitID: INTERSTITIAL_ID)

func initInterstitial() -> GADInterstitial
{
    if(!isInitialized)
    {
        isInitialized = true
        interstitial = GADInterstitial(adUnitID: INTERSTITIAL_ID)
        let Request  = GADRequest()
        interstitial!.loadRequest(Request)
        return interstitial!
    }
    return interstitial!
}

func ShowInterstitial(root: UIViewController?)
{
    if(interstitial!.isReady)
    {
        interstitial!.presentFromRootViewController(root)
        isInitialized = false
    }
}

enum InterstitialType
{
    case Admob
    case Chartboost
}

