//
//  GameViewController.swift
//  Take Them Down
//
//  Created by Pisi on 11/13/15.
//  Copyright (c) 2015 AznSoft. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds
import GameKit


extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

var ScreenSize : CGSize!
var bannerRef : GADBannerView!

class GameViewController: UIViewController {
    

    @IBOutlet weak var banner: GADBannerView!
    
    static func HideAds()
    {
        bannerRef.hidden = true
    }
    
    static func ShowAds()
    {
        bannerRef.hidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateLocalPlayer()
   //     print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        self.banner.adUnitID = BannerID
        self.banner.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "a90424ffe35d9f53288ab6bf2a3fd9dd"]
        self.banner.loadRequest(request)
        bannerRef = banner
        
        unlockCharacter("Hero1")
        setDefaultCharacter("Hero1")
        
        ScreenSize = self.view.frame.size
        let scene = GameScene(size: ScreenSize)
        scene.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        let SKview = self.view as! SKView?
        SKview?.presentScene(scene)
    }
    
    func authenticateLocalPlayer(){
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.presentViewController (viewController!, animated: true, completion: nil)
            }
            else {
                print((GKLocalPlayer.localPlayer().authenticated))
            }
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
