//
//  Green.swift
//  Scum
//
//  Created by Tommy Mallow on 11/12/17.
//  Copyright © 2017 Marshmallow. All rights reserved.
//

import SpriteKit

class Green: SKSpriteNode {
    
    private var textureAtlas = SKTextureAtlas();
    private var greenAnimation = [SKTexture]();
    private var animateGreenFly = SKAction();
    
    init() {
        let texture = SKTexture(imageNamed: "Green 1")
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
        textureAtlas = SKTextureAtlas(named: "Green.atlas");
        
        for i in 1...textureAtlas.textureNames.count {
            let name = "Green \(i)";
            greenAnimation.append(SKTexture(imageNamed: name));
        }
        animateGreenFly = SKAction.animate(with: greenAnimation, timePerFrame: 0.08, resize: true, restore: false);
        self.run(SKAction.repeatForever(animateGreenFly), withKey: "Green");
    }
}

