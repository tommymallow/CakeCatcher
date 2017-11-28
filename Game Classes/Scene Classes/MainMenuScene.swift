//
//  MainMenuScene.swift
//  Scum
//
//  Created by Tommy Mallow on 11/17/17.
//  Copyright © 2017 Marshmallow. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        GameManager.instance.initializeGameData();

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self);
            
            if nodes(at: location)[0].name == "Start" {
                
//                GameManager.instance.gameStartedFromMainMenu = true;
                
                let scene = GameplayScene(fileNamed: "GameplayScene");
                scene?.scaleMode = SKSceneScaleMode.aspectFill;
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
            }
            
            if nodes(at: location)[0].name == "Highscore" {
                let scene = HighscoreScene(fileNamed: "HighscoreScene");
                scene?.scaleMode = SKSceneScaleMode.aspectFill;
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
            }
            
        }
        
    }
}
