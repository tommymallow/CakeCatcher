//
//  Monster.swift
//  Scum
//
//  Created by Tommy Mallow on 11/11/17.
//  Copyright © 2017 Marshmallow. All rights reserved.
//

import SpriteKit

class Monster: SKSpriteNode {
    
    private var textureAtlasFly = SKTextureAtlas();
    private var textureAtlasHurt = SKTextureAtlas();

    private var monsterAnimationFly = [SKTexture]();
    private var monsterAnimationHurt = [SKTexture]();

    private var animateMonsterFly = SKAction();
    private var animateMonsterHurt = SKAction();

    private var turn = true;
    
    func initializeMonsterAndAnimations(){
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: (self.size.width / 2)-100);
        self.physicsBody?.affectedByGravity = false;
        self.physicsBody?.allowsRotation = false;
        self.physicsBody?.restitution = 0;
        self.physicsBody?.categoryBitMask = ColliderType.ENEMIES_AND_POWERUP;
        self.physicsBody?.collisionBitMask = ColliderType.PLAYER_AND_BULLET;
        self.physicsBody?.contactTestBitMask = ColliderType.PLAYER_AND_BULLET;
        
        //flying animation
        textureAtlasFly = SKTextureAtlas(named: "Monster.atlas");
        
        for i in 1...textureAtlasFly.textureNames.count {
            let name = "Monster \(i)";
            monsterAnimationFly.append(SKTexture(imageNamed: name));
        }
        animateMonsterFly = SKAction.animate(with: monsterAnimationFly, timePerFrame: 0.08, resize: true, restore: false);
        self.run(SKAction.repeatForever(animateMonsterFly), withKey: "Flying");
        
        //hurt animation
        textureAtlasHurt = SKTextureAtlas(named: "Hurt.atlas");
        
        for i in 1...textureAtlasHurt.textureNames.count {
            let name = "Hurt \(i)";
            monsterAnimationHurt.append(SKTexture(imageNamed: name));
        }
        animateMonsterHurt = SKAction.animate(with: monsterAnimationHurt, timePerFrame: 0.08, resize: true, restore: false);
        
    }
    
    func fly() {
        
        if self.position.x > 325 {
            turn = false;
        }
        
        if self.position.x < -325 {
            turn = true;
        }
        
        if turn == true {
            self.xScale = fabs(self.xScale);
            self.position.x += 5;
        } else {
            self.xScale = -fabs(self.xScale);
            self.position.x -= 5;
        }
        
    }
    
    func hurt() {
        self.physicsBody?.collisionBitMask = ColliderType.ENEMIES_AND_POWERUP;
        self.run(SKAction.repeat(animateMonsterHurt, count: 3));
        self.physicsBody?.collisionBitMask = ColliderType.PLAYER_AND_BULLET;
        
    }
}
