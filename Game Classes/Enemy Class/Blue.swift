//
//  Fly.swift
//  Scum
//
//  Created by Tommy Mallow on 11/12/17.
//  Copyright © 2017 Marshmallow. All rights reserved.
//

import SpriteKit

class Blue: SKSpriteNode {
    
    private var textureAtlas = SKTextureAtlas();
    private var blueAnimation = [SKTexture]();
    private var animateBlueFly = SKAction();
    
    init() {
        let texture = SKTexture(imageNamed: "Blue 1")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width-50, height: self.size.height-30));
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
        textureAtlas = SKTextureAtlas(named: "Blue.atlas");
        
        for i in 1...textureAtlas.textureNames.count {
            let name = "Blue \(i)";
            blueAnimation.append(SKTexture(imageNamed: name));
        }
        animateBlueFly = SKAction.animate(with: blueAnimation, timePerFrame: 0.08, resize: true, restore: false);
        self.run(SKAction.repeatForever(animateBlueFly), withKey: "Blue");
    }
    
}

