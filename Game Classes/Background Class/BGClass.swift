//
//  BGClass.swift
//  Scum
//
//  Created by Tommy Mallow on 11/11/17.
//  Copyright © 2017 Marshmallow. All rights reserved.
//

import SpriteKit

class BGClass: SKSpriteNode {
    
    
    func moveBG (camera: SKCameraNode) {
        if self.position.y + self.size.height + 10 < camera.position.y {
            self.position.y += self.size.height * 3;
        }
    }
    
    
    
    
    
}
