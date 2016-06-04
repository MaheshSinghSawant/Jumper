//
//  PlatformNode.swift
//  SwiftJump
//
//  Created by Mahesh Sawant on 6/3/16.
//  Copyright (c) 2016 Mahesh Sawant. All rights reserved.
//

import SpriteKit

class PlatformNode: GenericNode {

    var platformType:PlatformType!
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        if player.physicsBody?.velocity.dy < 0 {
            player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: 250)
            
            if platformType == PlatformType.breakableBrick {
                self.removeFromParent()
            }
            
        }
        
        return false
    }
    
    
}
