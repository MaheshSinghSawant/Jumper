//
//  FlowerNode.swift
//  SwiftJump
//
//  Created by Mahesh Sawant on 6/3/16.
//  Copyright (c) 2016 Mahesh Sawant. All rights reserved.
//

import SpriteKit

enum FlowerType:Int {
    case NormalFlower = 0
    case specialFlower = 1
}

class FlowerNode: GenericNode {

    var flowerType:FlowerType!
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: 400)
        
        GameHandler.sharedInstance.score += (flowerType == FlowerType.NormalFlower ? 20 : 100)
        GameHandler.sharedInstance.flowers += (flowerType == FlowerType.NormalFlower ? 1 : 5)
        
    
        self.removeFromParent()
        
        return true
    }
    
}
