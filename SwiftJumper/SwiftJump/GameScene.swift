//
//  GameScene.swift
//  SwiftJump
//
//  Created by Mahesh Sawant on 6/3/16.
//  Copyright (c) 2016 Mahesh Sawant. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background:SKNode!
    var midground:SKNode!
    var forefround:SKNode!
    
    var hud:SKNode!
    
    
    
    var player:SKNode!
    
    var scaleFactor:CGFloat!
    
    var startButton = SKSpriteNode(imageNamed: "TapToStart")
    
    var endOfGamePosition = 0
    
    let motionManager = CMMotionManager()
    
    var xAcceleration:CGFloat = 0.0
    
    var scoreLabel:SKLabelNode!
    var flowerLabel:SKLabelNode!
    
    var playersMaxY:Int!
    
    var gameOver = false
    
    var currentMaxY:Int!
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(size:CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.whiteColor()
        
        let levelData = GameHandler.sharedInstance.levelData
        
        
        currentMaxY = 80
        GameHandler.sharedInstance.score = 0
        gameOver = false
        
        
        endOfGamePosition = levelData!["EndOfLevel"]!.integerValue
        
        
        scaleFactor = self.size.width / 320
        

        background = createBackground()
        addChild(background)
        
        midground = createMidground()
        addChild(midground)
        
        forefround = SKNode()
        addChild(forefround)
        
        
        hud = SKNode()
        addChild(hud)
        
        startButton.position = CGPoint(x: self.size.width / 2, y: 180)
        hud.addChild(startButton)
        
        
        let flower = SKSpriteNode(imageNamed: "flower")
        flower.position = CGPoint(x: 25, y: self.size.height-30)
        hud.addChild(flower)
        
        
        flowerLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        flowerLabel.fontSize = 30
        flowerLabel.fontColor = SKColor.whiteColor()
        flowerLabel.position = CGPoint(x: 50, y: self.size.height-40)
        flowerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        
        
        flowerLabel.text = "  \(GameHandler.sharedInstance.flowers)"
        hud.addChild(flowerLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.position = CGPoint(x: self.size.width-20, y: self.size.height-40)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        
        scoreLabel.text = "0"
        hud.addChild(scoreLabel)

        
        
        
        
        player = createPlayer()
        forefround.addChild(player)
        
        let platforms = levelData["Platforms"] as! NSDictionary
        let platformPatterns = platforms["Patterns"] as! NSDictionary
        let platformPositions = platforms["Positions"] as! [NSDictionary]

        
        for platformPosition in platformPositions {
            let x = platformPosition["x"]?.floatValue
            let y = platformPosition["y"]?.floatValue
            let pattern = platformPosition["pattern"] as! NSString
            
            
            let platformPattern = platformPatterns[pattern] as! [NSDictionary]
            for platformPoint in platformPattern {
                let xValue = platformPoint["x"]?.floatValue
                let yValue = platformPoint["y"]?.floatValue
                let type = PlatformType(rawValue: platformPoint["type"]!.integerValue)
                let xPosition = CGFloat(xValue! + x!)
                let yPosition = CGFloat(yValue! + y!)
                
                let platformNode = createPlatformAtPosition(CGPoint(x: xPosition, y: yPosition), ofType: type!)
                forefround.addChild(platformNode)
            }
            
        }
        
        
        
        let flowers = levelData["Flowers"] as! NSDictionary
        let flowerPatterns = flowers["Patterns"] as! NSDictionary
        let flowerPositions = flowers["Positions"] as! [NSDictionary]
        
        
        for flowerPosition in flowerPositions {
            let x = flowerPosition["x"]?.floatValue
            let y = flowerPosition["y"]?.floatValue
            let pattern = flowerPosition["pattern"] as! NSString
            
            
            let flowerPattern = flowerPatterns[pattern] as! [NSDictionary]
            for flowerPoint in flowerPattern {
                let xValue = flowerPoint["x"]?.floatValue
                let yValue = flowerPoint["y"]?.floatValue
                let type = FlowerType(rawValue: flowerPoint["type"]!.integerValue)
                let xPosition = CGFloat(xValue! + x!)
                let yPosition = CGFloat(yValue! + y!)
                
                let flowerNode = createFlowerAtPosition(CGPoint(x: xPosition, y: yPosition), ofType: type!)
                forefround.addChild(flowerNode)
            }
            
        }
        

        
        
        
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        physicsWorld.contactDelegate = self
        
        motionManager.accelerometerUpdateInterval = 0.2
        
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (data:CMAccelerometerData?, error:NSError?) -> Void in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = (CGFloat(acceleration.x) * 0.75 + (self.xAcceleration * 0.25))
            }
        }
        
        
        
      
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var updateHUD = false
        
        var otherNode:SKNode!
        
        if contact.bodyA.node != player {
            otherNode = contact.bodyA.node
        }else{
            otherNode = contact.bodyB.node
        }
        
        updateHUD = (otherNode as! GenericNode).collisionWithPlayer(player)
        
        if updateHUD {
            flowerLabel.text = "  \(GameHandler.sharedInstance.flowers)"
            scoreLabel.text = "\(GameHandler.sharedInstance.score)"
        }
        
        
    }
    
    override func didSimulatePhysics() {
        player.physicsBody?.velocity = CGVector(dx: xAcceleration * 400, dy: player.physicsBody!.velocity.dy)
        
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        }else if (player.position.x > self.size.width + 20) {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        if player.physicsBody!.dynamic {
            return
        }
        
        startButton.removeFromParent()
        
        player.physicsBody?.dynamic = true
        
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        if gameOver {
            return
        }
        
        
        forefround.enumerateChildNodesWithName("PLATFORMNODE") { (node, stop) -> Void in
            let platform = node as! PlatformNode
            platform.shouldRemoveNode(self.player.position.y)
        }
        
        forefround.enumerateChildNodesWithName("FLOWERNODE") { (node, stop) -> Void in
            let flower = node as! FlowerNode
            flower.shouldRemoveNode(self.player.position.y)
        }
        
        
        if player.position.y > 200 {
            background.position = CGPoint(x: 0, y: -((player.position.y - 200)/10))
            midground.position = CGPoint(x: 0, y: -((player.position.y - 200)/4))
            forefround.position = CGPoint(x: 0, y: -((player.position.y - 200)))
        }
        
        
        if Int(player.position.y) > currentMaxY {
            GameHandler.sharedInstance.score += Int(player.position.y) - currentMaxY
            currentMaxY = Int(player.position.y)
            scoreLabel.text = "\(GameHandler.sharedInstance.score)"
            
        }
        
        if Int(player.position.y) > endOfGamePosition {
            endGame()
        }
        
        if Int(player.position.y) < currentMaxY - 800 {
            endGame()
        }
        
        
    }
    
    func endGame(){
        gameOver = true
        GameHandler.sharedInstance.saveGameStats()
        
        let transtion = SKTransition.fadeWithDuration(0.5)
        let endGameScene = EndGame(size: self.size)
        self.view?.presentScene(endGameScene, transition: transtion)
    }
}
