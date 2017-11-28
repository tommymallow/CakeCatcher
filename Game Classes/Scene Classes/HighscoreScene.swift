//
//  HighscoreScene.swift
//  Scum
//
//  Created by Tommy Mallow on 11/17/17.
//  Copyright © 2017 Marshmallow. All rights reserved.
//

import SpriteKit

class HighscoreScene: SKScene {
    
    private var scoreLabel: SKLabelNode?;
    
    override func didMove(to view: SKView) {
        getReference();
        setScore();
    }
    
    private func getReference() {
        scoreLabel = self.childNode(withName: "Score Label") as? SKLabelNode!;
    }
    
    private func setScore() {
            scoreLabel?.text = String(GameManager.instance.getScore());
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self);
            
            if nodes(at: location)[0].name == "Back" {
                let scene = MainMenuScene(fileNamed: "MainMenu");
                scene?.scaleMode = SKSceneScaleMode.aspectFill;
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
            }
            
        }
    
}

}
