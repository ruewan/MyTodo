//
//  AppDelegate.swift
//  MyTodo
//
//  Created by Adrian Layne on 7/10/19.
//  Copyright © 2019 Adrian Layne. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("^^^^^^^^^^^^^^^\(documentsPath)")
        do {
             _ = try Realm()
            
        } catch  {
            print("Error creating new realm")
        }
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    


}

