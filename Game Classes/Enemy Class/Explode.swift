//
//  Explode.swift
//  Scum
//
//  Created by Tommy Mallow on 11/15/17.
//  Copyright © 2017 Marshmallow. All rights reserved.
//

import SpriteKit


class Explode: SKSpriteNode {
    
    private var textureAtlas = SKTextureAtlas();
    private var explodeAnimation = [SKTexture]();
    private var animateExplode = SKAction();
    
    init() {
        let texture = SKTexture(imageNamed: "Explode 1")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        textureAtlas = SKTextureAtlas(named: "Explode.atlas");
        self.name = "Explode";
        for i in 1...textureAtlas.textureNames.count {
            let name = "Explode \(i)";
            explodeAnimation.append(SKTexture(imageNamed: name));
        }
        animateExplode = SKAction.animate(with: explodeAnimation, timePerFrame: 0.3, resize: true, restore: false);
        self.run(SKAction.repeatForever(animateExplode), withKey: "Explode");
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        let actionMoveDone = SKAction.removeFromParent()
        self.run(SKAction.sequence([animateExplode, actionMoveDone]));
    }
    
}



