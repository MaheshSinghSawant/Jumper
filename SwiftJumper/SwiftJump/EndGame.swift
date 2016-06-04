//  SwiftJump
//
//  Created by Mahesh Sawant on 6/3/16.
//  Copyright (c) 2016 Mahesh Sawant. All rights reserved.
//

import SpriteKit

class EndGame: SKScene {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let flower = SKSpriteNode(imageNamed: "flower")
        flower.position = CGPoint(x: 25, y: self.size.height-30)
        addChild(flower)
        
        let flowersLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        flowersLabel.fontSize = 30
        flowersLabel.fontColor = SKColor.whiteColor()
        flowersLabel.position = CGPoint(x: 50, y: self.size.height-40)
        flowersLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        
        flowersLabel.text = "  \(GameHandler.sharedInstance.flowers)"
        addChild(flowersLabel)
        
  
        let scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: 300)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        scoreLabel.text = "\(GameHandler.sharedInstance.score)"
        addChild(scoreLabel)
        

        let highScoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        highScoreLabel.fontSize = 30
        highScoreLabel.fontColor = SKColor.redColor()
        highScoreLabel.position = CGPoint(x: self.size.width / 2, y: 450)
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        highScoreLabel.text = "\(GameHandler.sharedInstance.highScore)"
        addChild(highScoreLabel)
        
        let tryAgainLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        tryAgainLabel.fontSize = 30
        tryAgainLabel.fontColor = SKColor.whiteColor()
        tryAgainLabel.position = CGPoint(x: self.size.width / 2, y: 50)
        tryAgainLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        tryAgainLabel.text = "Tap To Play Again"
        addChild(tryAgainLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let transition = SKTransition.fadeWithDuration(0.5)
        let gameScene = GameScene(size: self.size)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    
    
}
