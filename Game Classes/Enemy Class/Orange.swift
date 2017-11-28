//
//  Orange.swift
//  Scum
//
//  Created by Tommy Mallow on 11/12/17.
//  Copyright © 2017 Marshmallow. All rights reserved.
//

import SpriteKit

struct ColliderType {
    static let PLAYER_AND_BULLET: UInt32 = 0;
    static let ENEMIES_AND_POWERUP: UInt32 = 1;
    static let MONSTER: UInt32 = 2;
    static let OTHER: UInt32 = 3;
}

class Orange: SKSpriteNode {

    private var textureAtlas = SKTextureAtlas();
    private var orangeAnimation = [SKTexture]();
    private var animateOrangeFly = SKAction();

    init() {
        let texture = SKTexture(imageNamed: "Orange 1")
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
            textureAtlas = SKTextureAtlas(named: "Orange.atlas");
            
            for i in 1...textureAtlas.textureNames.count {
                let name = "Orange \(i)";
                orangeAnimation.append(SKTexture(imageNamed: name));
            }
            animateOrangeFly = SKAction.animate(with: orangeAnimation, timePerFrame: 0.3, resize: true, restore: false);
            self.run(SKAction.repeatForever(animateOrangeFly), withKey: "Orange");
    }

}


