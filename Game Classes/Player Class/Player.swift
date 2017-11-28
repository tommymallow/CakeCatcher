//
//  Player.swift
//  Scum
//
//  Created by Tommy Mallow on 11/14/17.
//  Copyright © 2017 Marshmallow. All rights reserved.
//

import SpriteKit
import CoreMotion

class Player: SKSpriteNode {
    
    private var left = true;
    private var camera = SKCameraNode();
    private var textureAtlasFly = SKTextureAtlas();
    private var textureAtlasShoot = SKTextureAtlas();
    private var textureAtlasInjured = SKTextureAtlas();

    private var playerAnimationFly = [SKTexture]();
    private var playerAnimationShoot = [SKTexture]();
    private var playerAnimationInjured = [SKTexture]();

    private var animatePlayerFly = SKAction();
    private var animatePlayerShoot = SKAction();
    private var animatePlayerInjured = SKAction();
    
    
    func initializePlayerAndAnimations(){
        
        textureAtlasFly = SKTextureAtlas(named: "Player.atlas");
        for i in 1...textureAtlasFly.textureNames.count {
            let name = "Player \(i)";
            playerAnimationFly.append(SKTexture(imageNamed: name));
        }
        animatePlayerFly = SKAction.animate(with: playerAnimationFly, timePerFrame: 0.08, resize: false, restore: false);
        self.run(SKAction.repeatForever(animatePlayerFly), withKey: "Fly");
        
        
        textureAtlasShoot = SKTextureAtlas(named: "Shooting.atlas");
        for i in 1...textureAtlasShoot.textureNames.count {
            let name = "Shooting \(i)";
            playerAnimationShoot.append(SKTexture(imageNamed: name));
        }
        animatePlayerShoot = SKAction.animate(with: playerAnimationShoot, timePerFrame: 0.08, resize: false, restore: false);
        
        
        textureAtlasInjured = SKTextureAtlas(named: "Injured.atlas");
        for i in 1...textureAtlasInjured.textureNames.count {
            let name = "Injured \(i)";
            playerAnimationInjured.append(SKTexture(imageNamed: name));
        }
        animatePlayerInjured = SKAction.animate(with: playerAnimationInjured, timePerFrame: 0.08, resize: false, restore: false);
        
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width - 70, height: self.size.height));
        self.physicsBody?.affectedByGravity = true;
        self.physicsBody?.allowsRotation = false;
        self.physicsBody?.restitution = 0;
        self.physicsBody?.categoryBitMask = ColliderType.PLAYER_AND_BULLET;
        self.physicsBody?.collisionBitMask = ColliderType.ENEMIES_AND_POWERUP;
        self.physicsBody?.contactTestBitMask = ColliderType.ENEMIES_AND_POWERUP;
    }
    
    func startShoot(left: Bool, camera: SKCameraNode) {
        self.removeAction(forKey: "Fly");
        self.run(SKAction.repeatForever(animatePlayerShoot), withKey: "Shoot");
        self.left = left;
        self.camera = camera;
        if (left == true){
            self.xScale = fabs(self.xScale);
        } else {
            self.xScale = -fabs(self.xScale);
        }
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(createBullet),
                SKAction.wait(forDuration: 0.5)
                ])), withKey: "Bullet");
    
    }
    
    func stopShoot() {
        self.removeAction(forKey: "Shoot");
        self.removeAction(forKey: "Bullet");
        self.run(SKAction.repeatForever(animatePlayerFly), withKey: "Fly");
    }
    
    
    func createBullet() {
        let bullet = Bullet();
        bullet.name = "Bullet";
        bullet.xScale = 0.18;
        bullet.yScale = 0.18;
        bullet.zPosition = 3;
        var actionOne = SKAction();
        if (left == true){
        bullet.position = CGPoint(x: (self.position.x) + 50, y: (self.position.y));
        bullet.xScale = fabs(bullet.xScale);
        actionOne = SKAction.move(to: CGPoint(x: bullet.position.x + 700, y: bullet.position.y), duration: TimeInterval(0.6))
        } else {
        bullet.position = CGPoint(x: (self.position.x) - 50, y: (self.position.y));
        bullet.xScale = -fabs(bullet.xScale);
        actionOne = SKAction.move(to: CGPoint(x: bullet.position.x - 700, y: bullet.position.y), duration: TimeInterval(0.6))
        }
        let actionMoveDone = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([actionOne, actionMoveDone]))
        camera.addChild(bullet);
        bullet.animate();

    }
    
    func hurt() {
        self.run(SKAction.repeat(animatePlayerInjured, count: 4));
    }
}



