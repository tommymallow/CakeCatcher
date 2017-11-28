//
//  Pinky.swift
//  Scum
//
//  Created by Tommy Mallow on 11/12/17.
//  Copyright © 2017 Marshmallow. All rights reserved.
//

import SpriteKit

class Pinky: SKSpriteNode {
    
    private var textureAtlas = SKTextureAtlas();
    private var pinkyAnimation = [SKTexture]();
    private var animatePinkyFly = SKAction();
    
    init() {
        let texture = SKTexture(imageNamed: "Pinky 1")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.physicsBody = SKPhysicsBody(circleOfRadius: (self.size.width / 2)-40);
        self.physicsBody?.affectedByGravity = false;
        self.physicsBody?.allowsRotation = false;
        self.physicsBody?.restitution = 0;
        self.physicsBody?.categoryBitMask = ColliderType.ENEMIES_AND_POWERUP;
        self.physicsBody?.collisionBitMask = ColliderType.PLAYER_AND_BULLET;
        self.physicsBody?.contactTestBitMask = ColliderType.PLAYER_AND_BULLET;
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        textureAtlas = SKTextureAtlas(named: "Pinky.atlas");
        
        for i in 1...textureAtlas.textureNames.count {
            let name = "Pinky \(i)";
            pinkyAnimation.append(SKTexture(imageNamed: name));
        }
        animatePinkyFly = SKAction.animate(with: pinkyAnimation, timePerFrame: 0.3, resize: true, restore: false);
        self.run(SKAction.repeatForever(animatePinkyFly), withKey: "Pinky");
    }
}
