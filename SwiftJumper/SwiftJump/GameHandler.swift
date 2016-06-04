//
//  GameHandler.swift
//  SwiftJump
//
//  Created by Mahesh Sawant on 6/3/16.
//  Copyright (c) 2016 Mahesh Sawant. All rights reserved.
//

import Foundation

class GameHandler {
    var score:Int
    var highScore:Int
    var flowers:Int
    
    var levelData:NSDictionary!
    
    class var sharedInstance:GameHandler {
        struct Singleton {
            static let instance = GameHandler()
        }
        
        return Singleton.instance
    }
    
    init(){
        score = 0
        highScore = 0
        flowers = 0
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        highScore = userDefaults.integerForKey("highScore")
        flowers = userDefaults.integerForKey("flowers")
        
        
        if let path = NSBundle.mainBundle().pathForResource("Level01", ofType: "plist") {
            if let level = NSDictionary(contentsOfFile: path) {
                levelData = level
            }
        }
        
        
    }
    
    func saveGameStats() {
        highScore = max(score,highScore)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(highScore, forKey: "highScore")
        userDefaults.setInteger(flowers, forKey: "flowers")
        userDefaults.synchronize()
        
    }
}