//
//  GameplayController.swift
//  Scum
//
//  Created by Tommy Mallow on 11/17/17.
//  Copyright © 2017 Marshmallow. All rights reserved.
//

import Foundation
import SpriteKit

class GameplayController {
    static let instance = GameplayController();
    private init() {}
    
    var scoreText: SKLabelNode?;
    var lifeText: SKLabelNode?;
    
    var score: Int = 0;
    var life: Int = 0;
    
    func initializeVariables() {
            score = 0;
            life = 3;
            
            scoreText?.text = "\(score)";
            lifeText?.text = "\(life)";
    }
    
    func incrementScore() {
        score += 1;
        scoreText?.text = "\(score)"
    }
    
    func incrementLife() {
        life += 1;
        lifeText?.text = "\(life)"
        scoreText?.text = "\(score)"
        
        
    }
    
}



































