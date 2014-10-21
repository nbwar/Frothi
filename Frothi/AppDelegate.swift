//
//  AppDelegate.swift
//  Frothi
//
//  Created by Nicholas Wargnier on 10/13/14.
//  Copyright (c) 2014 nick. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var facebookReadPermissions = ["public_profile", "email"]


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    var homeController:AnyObject?
    
//    Delete this line
    CurrentUser.sharedInstance.clearToken()
    
    
    let sideMenuStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
    let sideMenuController = sideMenuStoryboard.instantiateInitialViewController() as SideMenuController

    if CurrentUser.sharedInstance.isLoggedIn() {
      let mainStoryboard = UIStoryboard(name: "Home", bundle: nil)
      homeController = mainStoryboard.instantiateInitialViewController() as UINavigationController
      sideMenuController.homeController = homeController as UINavigationController
    } else {
      let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
      homeController = loginStoryboard.instantiateInitialViewController() as LoginController
    }



    
    var revealController = SWRevealViewController(rearViewController: sideMenuController, frontViewController: homeController as UIViewController)
//        revealController.rearViewRevealWidth = 215
    
    window?.rootViewController = revealController
    window?.makeKeyAndVisible()

    return true
  }
  
//  Facebook
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: NSString?, annotation: AnyObject) -> Bool {
    return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
  }
//
//  func sessionStateChanged(session:FBSession, state:FBSessionState, error:NSError?) {
//    
//  }

  func applicationWillResignActive(application: UIApplication) {
  }

  func applicationDidEnterBackground(application: UIApplication) {
  }

  func applicationWillEnterForeground(application: UIApplication) {
  }

  func applicationDidBecomeActive(application: UIApplication) {
    FBAppCall.handleDidBecomeActive()
  }

  func applicationWillTerminate(application: UIApplication) {
  }
}

