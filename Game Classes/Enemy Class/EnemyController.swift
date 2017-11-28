//
//  Orange.swift
//  Scum
//
//  Created by Tommy Mallow on 11/11/17.
//  Copyright © 2017 Marshmallow. All rights reserved.
//

import SpriteKit

class EnemyController: SKSpriteNode {
    
    
    func createEnemy(scene: SKScene, monster: SKSpriteNode, camera: SKCameraNode) {
        
        let rand = Int(arc4random_uniform(8));
        
        var enemy = SKSpriteNode();
        
        switch(rand) {
        case 1:
        let orange = Orange();
        orange.name = "orange";
        enemy = orange;
        enemy.xScale = 0.12;
        enemy.yScale = 0.12;
        enemy.position = CGPoint(x: monster.position.x, y: camera.position.y + 510);
        scene.addChild(enemy);
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: monster.position.x, y: monster.position.y - 300), duration: TimeInterval(6))
        let actionMoveDone = SKAction.removeFromParent()
        monster.run(SKAction.sequence([actionMove, actionMoveDone]))
        print("orange");
        break;
        case 3:
        let pinky = Pinky();
        pinky.name = "pinky";
        enemy = pinky;
        print("pinky");
        break;
        case 4:
        let fly = SKSpriteNode(imageNamed: "Fly 1");
        fly.name = "fly";
        enemy = fly;
        print("fly");
        break;
        case 5:
        let bee = SKSpriteNode(imageNamed: "Bee 1");
        bee.name = "bee";
        enemy = bee;
        print("bee");
        break;
        default:
            return;
        }
        
    }
    
}
