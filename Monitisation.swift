//
//  Monitisation.swift
//  Canon Hero
//
//  Created by KHALID on 18/09/15.
//  Copyright (c) 2015 KHALID. All rights reserved.
//

import GoogleMobileAds

var TO_SHOW_INTERSTITIAL = 3 // NUMBER OF GAMEOVER TO SHOW INTERSTITAL

var interstitialType = InterstitialType.Admob// CHANGE TO InterstitialType.Admob TO SHOW ADMOB INTERSTITIAL
let kChartboostAppID = "55fc17f95b145366b541a641" // Chartboost APP ID
let kChartboostAppSignature = "2f936b94defd66caefadf4fa1256e37ae9ab41d2" // Chartboost App Signature

var INTERSTITIAL_ID = "ca-app-pub-9501203044398619/6802870682" // ADMOB INTERSTITAL ID
var BannerID = "ca-app-pub-9501203044398619/5326137481" // ADMOB BANNER ID


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

