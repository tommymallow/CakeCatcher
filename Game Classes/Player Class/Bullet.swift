//
//  Bullet.swift
//  Scum
//
//  Created by Tommy Mallow on 11/14/17.
//  Copyright © 2017 Marshmallow. All rights reserved.
//

import Foundation

import SpriteKit

class Bullet: SKSpriteNode {
    
    private var textureAtlas = SKTextureAtlas();
    private var bulletAnimation = [SKTexture]();
    private var animateBulletFly = SKAction();
    
    init() {
        let texture = SKTexture(imageNamed: "Bullet 1")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width-40, height: self.size.height));
        self.physicsBody?.affectedByGravity = false;
        self.physicsBody?.allowsRotation = false;
        self.physicsBody?.restitution = 0;
        self.physicsBody?.categoryBitMask = ColliderType.PLAYER_AND_BULLET;
        self.physicsBody?.collisionBitMask = ColliderType.ENEMIES_AND_POWERUP;
        self.physicsBody?.contactTestBitMask = ColliderType.ENEMIES_AND_POWERUP;
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        textureAtlas = SKTextureAtlas(named: "Bullet.atlas");
        
        for i in 1...textureAtlas.textureNames.count {
            let name = "Bullet \(i)";
            bulletAnimation.append(SKTexture(imageNamed: name));
        }
        animateBulletFly = SKAction.animate(with: bulletAnimation, timePerFrame: 0.3, resize: true, restore: false);
        self.run(SKAction.repeatForever(animateBulletFly), withKey: "Animate");
    }
    
}


