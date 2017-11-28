//
//  GameplayScene.swift
//  Scum
//
//  Created by Tommy Mallow on 11/10/17.
//  Copyright © 2017 Marshmallow. All rights reserved.
//

import SpriteKit
import UIKit
import CoreMotion

class GameplayScene: SKScene, SKPhysicsContactDelegate {
    
    var manager = CMMotionManager();
    var player = Player();
    var monster: Monster?;
    var mainCamera: SKCameraNode?;
    var bg1: BGClass?;
    var bg2: BGClass?;
    var bg3: BGClass?;
    var borderBottom = SKSpriteNode();
    var borderTop = SKSpriteNode();
    var scoreBG = SKSpriteNode();
    var scoreIcon = SKSpriteNode();
    var scoreLabel = SKLabelNode();
    var healthBG = SKSpriteNode();
    var healthIcon = SKSpriteNode();
    var healthLabel = SKLabelNode();
    var pauseBG = SKSpriteNode();
    var pauseIcon = SKSpriteNode();
    var countEnemies = 0;
    var random = 3;
    var center: CGFloat?;
    var left = true;
    var exists = false;
    var displaySize = CGRect();
    
    
    private var pausePanel: SKSpriteNode?;

    
    override func didMove(to view: SKView) {
        initializeVariables();
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveCamera();
        manageBackgrounds();
        monster?.fly();
     //   checkForChildsOffScreen();
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody = contact.bodyA;
        var secondBody = contact.bodyB;
        
        if contact.bodyA.node?.name == "Player" || contact.bodyA.node?.name == "Bullet"{
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        } else {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Enemy" {
//            self.run(SKAction.playSoundFileNamed("Life Sound.wav", waitForCompletion: false));
            player.hurt();
//            explode(node: secondBody.node!);

            let health = Health();
            health.name = "Health";
            health.xScale = 0.2;
            health.yScale = 0.2;
            health.zPosition = 2;
            
            if((secondBody.node?.position.x)! > CGFloat(0)) {
            health.position = CGPoint(x: (secondBody.node?.position.x)!+100, y: (secondBody.node?.position.y)!-85);
            } else {
            health.position = CGPoint(x: (secondBody.node?.position.x)!-100, y: (secondBody.node?.position.y)!-85);
            }
            scene?.addChild(health);
            // Create the actions
            let actionMove = SKAction.move(to: CGPoint(x: (monster?.position.x)!, y: (health.position.y) - 1400), duration: TimeInterval(15));
            let actionMoveDone = SKAction.removeFromParent();
            health.run(SKAction.sequence([actionMove, actionMoveDone]));
            
            secondBody.node?.removeFromParent();
            GameplayController.instance.life -= 1;
            
            if GameplayController.instance.life > 0 {
                GameplayController.instance.lifeText?.text = "\(GameplayController.instance.life)";
            } else {
                self.scene?.isPaused = true;
                GameplayController.instance.lifeText?.text = "\(GameplayController.instance.life)";
                createEndScorePanel();
                Timer.scheduledTimer(timeInterval: TimeInterval(4), target: self, selector: #selector(GameplayScene.playerDied), userInfo: nil, repeats: false);
            }

        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Monster" {
//            monster?.hurt();
            player.hurt();
//            explode(node: secondBody.node!);
            
            let health = Health();
            health.name = "Health";
            health.xScale = 0.2;
            health.yScale = 0.2;
            health.zPosition = 2;
            health.position = CGPoint(x: (monster?.position.x)!, y: (mainCamera?.position.y)! + 600);
            scene?.addChild(health);
            // Create the actions
            let actionMove = SKAction.move(to: CGPoint(x: (monster?.position.x)!, y: (health.position.y) - 1400), duration: TimeInterval(15));
            let actionMoveDone = SKAction.removeFromParent();
            health.run(SKAction.sequence([actionMove, actionMoveDone]));
            
            GameplayController.instance.life -= 1;
            
            if GameplayController.instance.life > 0 {
                GameplayController.instance.lifeText?.text = "\(GameplayController.instance.life)";
            } else {
                self.scene?.isPaused = true;
                GameplayController.instance.lifeText?.text = "\(GameplayController.instance.life)";
                createEndScorePanel();
                Timer.scheduledTimer(timeInterval: TimeInterval(4), target: self, selector: #selector(GameplayScene.playerDied), userInfo: nil, repeats: false);
            }
        }
        
        if firstBody.node?.name == "Bullet" && secondBody.node?.name == "Monster" {
            
            monster?.hurt();
            firstBody.node?.removeFromParent();
            
            cakeCheck();
            
            if (!exists) {
            let cake = Cake();
            cake.name = "Cake";
            cake.xScale = 0.8;
            cake.yScale = 0.8;
            cake.zPosition = 2;
            cake.position = CGPoint(x: (monster?.position.x)!, y: (mainCamera?.position.y)! + 600);
            scene?.addChild(cake);
            // Create the actions
            let actionMove = SKAction.move(to: CGPoint(x: (monster?.position.x)!, y: (cake.position.y) - 200), duration: TimeInterval(7));
            let actionMoveDone = SKAction.removeFromParent();
            cake.run(SKAction.sequence([actionMove, actionMoveDone]));
            }
            
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Health" {
           GameplayController.instance.incrementLife();
            secondBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Cake" {
            GameplayController.instance.incrementScore();
            secondBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "Bullet" && secondBody.node?.name == "Enemy" {
            explode(node: secondBody.node!);
            firstBody.node?.removeFromParent();
            secondBody.node?.removeFromParent();
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self);
            
            if nodes(at: location)[0].name != "Pause" && nodes(at: location)[0].name != "Resume" && nodes(at: location)[0].name != "Quit" {
                if !self.scene!.isPaused {
                    if location.x > center! {
                        player.startShoot(left: true, camera: mainCamera!);
                    } else {
                        player.startShoot(left: false, camera: mainCamera!);
                    }
                }
            }
            
            if nodes(at: location)[0].name == "Pause" {
                if !self.scene!.isPaused {
                self.scene?.isPaused = true;
                createPausePanel();
                }
            }
            
            if nodes(at: location)[0].name == "Resume" {
                self.pausePanel?.removeFromParent();
                self.scene?.isPaused = false;
            }
            
            if nodes(at: location)[0].name == "Retry" {
                let highscore = GameManager.instance.getScore();
                if highscore < Int32(GameplayController.instance.score) {
                    GameManager.instance.setScore(Int32(GameplayController.instance.score));
                }
                
                GameManager.instance.saveData();
                let scene = GameplayScene(fileNamed: "GameplayScene");
                scene?.scaleMode = SKSceneScaleMode.aspectFill;
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
            }
            
            if nodes(at: location)[0].name == "Quit" {
                let highscore = GameManager.instance.getScore();
                if highscore < Int32(GameplayController.instance.score) {
                    GameManager.instance.setScore(Int32(GameplayController.instance.score));
                }
                
                GameManager.instance.saveData();
                let scene = MainMenuScene(fileNamed: "MainMenu");
                scene?.scaleMode = SKSceneScaleMode.aspectFill;
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
            }
                
            }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopShoot();
    }
    
    
        
        func initializePlayer() {
            
            player = mainCamera?.childNode(withName: "Player") as! Player;

            manager.startAccelerometerUpdates();
            manager.accelerometerUpdateInterval = 0.3;
            manager.startAccelerometerUpdates(to: OperationQueue.main){
                (data, error) in
                
                self.physicsWorld.gravity = CGVector(dx: (CGFloat((data?.acceleration.x)!)) * 20, dy: ((CGFloat((data?.acceleration.y)!))+0.65) * 20);
            }
            player.initializePlayerAndAnimations();
    }

    
    func initializeVariables() {
        displaySize = UIScreen.main.bounds;
        let displayWidth = displaySize.width;
        let displayHeight = displaySize.height;
        print("display height: ");
        print(displayHeight * 0.8);
        physicsWorld.contactDelegate = self;
        center = self.frame.size.width / self.frame.size.height;
        mainCamera = self.childNode(withName: "Main Camera") as? SKCameraNode;
        monster = mainCamera?.childNode(withName: "Monster") as? Monster;
        monster?.position.y = displayHeight * 0.89;
        monster?.initializeMonsterAndAnimations();
        borderTop = (mainCamera?.childNode(withName: "Border 3")) as! SKSpriteNode;
        borderTop.position.y = displayHeight;
        borderBottom = (mainCamera?.childNode(withName: "Border 1")) as! SKSpriteNode;
        borderBottom.position.y = -displayHeight;
        scoreBG = (mainCamera?.childNode(withName: "ScoreBG")) as! SKSpriteNode;
        scoreIcon = (mainCamera?.childNode(withName: "Cake")) as! SKSpriteNode;
        scoreLabel = (mainCamera?.childNode(withName: "Score Label")) as! SKLabelNode;
        healthBG = (mainCamera?.childNode(withName: "HealthBG")) as! SKSpriteNode;
        healthIcon = (mainCamera?.childNode(withName: "Health")) as! SKSpriteNode;
        healthLabel = (mainCamera?.childNode(withName: "Health Label")) as! SKLabelNode;
        pauseBG = (mainCamera?.childNode(withName: "PauseBG")) as! SKSpriteNode;
        pauseIcon = (mainCamera?.childNode(withName: "Pause")) as! SKSpriteNode;
        scoreBG.position.y = displayHeight - (displayHeight * 1.68);
        scoreIcon.position.y = displayHeight - (displayHeight * 1.68);
        scoreLabel.position.y = displayHeight - (displayHeight * 1.7);
        healthBG.position.y = displayHeight - (displayHeight * 1.79);
        healthIcon.position.y = displayHeight - (displayHeight * 1.79);
        healthLabel.position.y = displayHeight - (displayHeight * 1.81);
        pauseBG.position.y = displayHeight - (displayHeight * 1.9);
        pauseIcon.position.y = displayHeight - (displayHeight * 1.9);
        
        if (displayHeight == 812) {
            monster?.position.y = displayHeight * 0.65;
            borderTop.position.y = displayHeight * 0.8;
            borderBottom.position.y = displayHeight * -0.8;
            scoreBG.position.y = displayHeight - (displayHeight * 1.55);
            scoreIcon.position.y = displayHeight - (displayHeight * 1.55);
            scoreLabel.position.y = displayHeight - (displayHeight * 1.57);
            healthBG.position.y = displayHeight - (displayHeight * 1.65);
            healthIcon.position.y = displayHeight - (displayHeight * 1.65);
            healthLabel.position.y = displayHeight - (displayHeight * 1.67);
            pauseBG.position.y = displayHeight - (displayHeight * 1.75);
            pauseIcon.position.y = displayHeight - (displayHeight * 1.75);

            pauseIcon.position.x = displayWidth * -0.73;
            scoreBG.position.x = displayWidth * -0.8;
            scoreIcon.position.x = displayWidth * -0.73;
            scoreLabel.position.x = displayWidth * -0.6;
            healthBG.position.x = displayWidth * -0.8;
            healthIcon.position.x = displayWidth * -0.73;
            healthLabel.position.x = displayWidth * -0.6;
            pauseBG.position.x = displayWidth * -0.87;
        }

        initializePlayer();
        getBackgrounds();
        manageEnemies();
        getLabels();
        GameplayController.instance.initializeVariables();
    }
    
    func getBackgrounds(){
        bg1 = self.childNode(withName: "BG 1") as! BGClass!;
        bg2 = self.childNode(withName: "BG 2") as! BGClass!;
        bg3 = self.childNode(withName: "BG 3") as! BGClass!;

    }
    
    
    func moveCamera() {
        self.mainCamera?.position.y += 3;
    }
    
    func manageBackgrounds() {
        bg1?.moveBG(camera: mainCamera!);
        bg2?.moveBG(camera: mainCamera!);
        bg3?.moveBG(camera: mainCamera!);

    }
    
//    func checkForChildsOffScreen() {
//        for child in children {
//            if child.position.y < (mainCamera?.position.y)! - (self.scene?.size.height)! + 200 {
//                let childName = child.name?.components(separatedBy: " ");
//
//                if childName![0] != "BG" {
//                    print("the child removed is \(String(describing: child.name))");
//                    child.removeFromParent();
//                }
//
//        }
//        }
//
//    }
    
    func manageEnemies() {
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(createEnemy),
                SKAction.wait(forDuration: 0.3)
                ])))
        }
    
    
    func createEnemy() {
       
        if countEnemies == 15 {
            random = 12;
        } else if countEnemies == 25 {
            random = 17;
        } else if countEnemies == 40 {
            random = 21;
        }

        countEnemies+=1;
        let rand = Int(arc4random_uniform(UInt32(random)));
        switch(rand) {
        case 1:
            let orange = Orange();
            orange.name = "Enemy";
            orange.xScale = 0.12;
            orange.yScale = 0.12;
            orange.zPosition = 2;
            orange.position = CGPoint(x: (monster?.position.x)!, y: (mainCamera?.position.y)! + 510);
            scene?.addChild(orange);
            orange.animate();
            // Create the actions
            let actionMove = SKAction.move(to: CGPoint(x: (monster?.position.x)!, y: (orange.position.y) - 1400), duration: TimeInterval(8));
            let actionMoveDone = SKAction.removeFromParent();
            orange.run(SKAction.sequence([actionMove, actionMoveDone]));
            break;
        case 11:
            let pinky = Pinky();
            pinky.name = "Enemy";
            pinky.xScale = 0.12;
            pinky.yScale = 0.12;
            pinky.zPosition = 2;
            pinky.position = CGPoint(x: (monster?.position.x)!, y: (mainCamera?.position.y)! + 510);
            scene?.addChild(pinky);
            pinky.animate();
            // Create the actions
            let actionMove = SKAction.move(to: CGPoint(x: (monster?.position.x)!, y: (pinky.position.y) - 1400), duration: TimeInterval(5))
            let actionMoveDone = SKAction.removeFromParent()
            pinky.run(SKAction.sequence([actionMove, actionMoveDone]))
            break;
        case 16:
            let blue = Blue();
            blue.name = "Enemy";
            blue.xScale = 0.11;
            blue.yScale = 0.11;
            blue.zPosition = 2;
            blue.position = CGPoint(x: (monster?.position.x)!, y: (mainCamera?.position.y)! + 510);
            scene?.addChild(blue);
            blue.animate();
            // Create the actions
            var moveAmount = CGFloat();
            if (blue.position.x > 0) {
                blue.xScale = -fabs(blue.xScale);
                moveAmount = blue.position.x - 700;
            } else {
                moveAmount = blue.position.x + 700;
            }
            
            let actionMove = SKAction.move(to: CGPoint(x: moveAmount, y: (blue.position.y) - 1400), duration: TimeInterval(10))
            let actionMoveDone = SKAction.removeFromParent()
            blue.run(SKAction.sequence([actionMove, actionMoveDone]))
            break;
        case 20:
            let green = Green();
            green.name = "Enemy";
            green.xScale = 0.07;
            green.yScale = 0.07;
            green.zPosition = 2;
            green.position = CGPoint(x: (monster?.position.x)!, y: (mainCamera?.position.y)! + 510);
            scene?.addChild(green);
            green.animate();
            // Create the actions
            let actionOne = SKAction.move(to: CGPoint(x: green.position.x - 25, y: (green.position.y) - 25), duration: TimeInterval(0.25))
            let flip = SKAction.scaleX(to: fabs(green.xScale), duration: 0.0001)
            let actionTwo = SKAction.move(to: CGPoint(x: green.position.x + 50, y: (green.position.y) - 100), duration: TimeInterval(0.75))
            let flipAgain = SKAction.scaleX(to: -fabs(green.xScale), duration: 0.0001)
            let actionThree = SKAction.move(to: CGPoint(x: green.position.x - 50, y: (green.position.y) - 175), duration: TimeInterval(0.75))
            let actionFour = SKAction.move(to: CGPoint(x: green.position.x + 50, y: (green.position.y) - 250), duration: TimeInterval(0.75))
            let actionFive = SKAction.move(to: CGPoint(x: green.position.x - 50, y: (green.position.y) - 325), duration: TimeInterval(0.75))
            let actionSix = SKAction.move(to: CGPoint(x: green.position.x + 50, y: (green.position.y) - 400), duration: TimeInterval(0.75))
            let actionSeven = SKAction.move(to: CGPoint(x: green.position.x - 50, y: (green.position.y) - 475), duration: TimeInterval(0.75))
            let actionEight = SKAction.move(to: CGPoint(x: green.position.x + 50, y: (green.position.y) - 550), duration: TimeInterval(0.75))
            let actionNine = SKAction.move(to: CGPoint(x: green.position.x - 50, y: (green.position.y) - 625), duration: TimeInterval(0.75))
            let actionTen = SKAction.move(to: CGPoint(x: green.position.x + 50, y: (green.position.y) - 700), duration: TimeInterval(0.75))
            let actionEleven = SKAction.move(to: CGPoint(x: green.position.x - 50, y: (green.position.y) - 775), duration: TimeInterval(0.75))
            let actionMoveDone = SKAction.removeFromParent()
            green.run(SKAction.sequence([actionOne, flip, actionTwo, flipAgain, actionThree, flip, actionFour, flipAgain, actionFive, flip, actionSix, flipAgain, actionSeven, flip, actionEight, flipAgain, actionNine, flip, actionTen, flipAgain, actionEleven, flip, actionMoveDone]))
            break;
        default:
            countEnemies-=1;
            return;
        }
    }
        
        func explode(node: SKNode) {
            let explode = Explode();
            explode.xScale = 0.2;
            explode.yScale = 0.2;
            explode.zPosition = 6;
            explode.position = CGPoint(x: (node.position.x), y: (node.position.y));
            scene?.addChild(explode);
            explode.animate();
        }
    
    
    private func createPausePanel() {
        
        pausePanel = SKSpriteNode(imageNamed: "Paused copy");
        let resumeBtn = SKSpriteNode(imageNamed: "Resume");
        let quitBtn = SKSpriteNode(imageNamed: "Quit");
        
        pausePanel?.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        pausePanel?.xScale = 1;
        pausePanel?.yScale = 1;
        pausePanel?.zPosition = 6;
        
        pausePanel?.position = CGPoint(x: self.mainCamera!.frame.size.width / 2, y: self.mainCamera!.frame.size.height / 2);
        
        resumeBtn.name = "Resume";
        resumeBtn.zPosition = 6;
        resumeBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        resumeBtn.xScale = 1.8;
        resumeBtn.yScale = 1.8;
        resumeBtn.position = CGPoint(x: pausePanel!.position.x, y: pausePanel!.position.y + 90);
        
        quitBtn.name = "Quit";
        quitBtn.zPosition = 6;
        quitBtn.xScale = 1.8;
        quitBtn.yScale = 1.8;
        quitBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        quitBtn.position = CGPoint(x: pausePanel!.position.x, y: pausePanel!.position.y - 100);
        
        pausePanel?.addChild(resumeBtn);
        pausePanel?.addChild(quitBtn);
        
        self.mainCamera?.addChild(pausePanel!);
        
    }
    
    private func createEndScorePanel() {
        let endScorePanel = SKSpriteNode(imageNamed: "ShowScore copy");
        let scoreLabel = SKLabelNode(fontNamed: "SnowDream");
        let retryBtn = SKSpriteNode(imageNamed: "Retry");

        retryBtn.name = "Retry";
        retryBtn.zPosition = 6;
        retryBtn.xScale = 1.4;
        retryBtn.yScale = 1.4;
        retryBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        retryBtn.position = CGPoint(x: endScorePanel.position.x, y: endScorePanel.position.y-170);
        
        endScorePanel.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        endScorePanel.zPosition = 8;
        
        scoreLabel.text = "\(GameplayController.instance.score)"
        
        endScorePanel.addChild(retryBtn);
        endScorePanel.addChild(scoreLabel);
        
        scoreLabel.fontSize = 70;
        scoreLabel.zPosition = 7;
        
        endScorePanel.position = CGPoint(x: mainCamera!.frame.size.width / 2, y: mainCamera!.frame.size.height / 2);
        
        scoreLabel.position = CGPoint(x: endScorePanel.position.x+10, y: endScorePanel.position.y-8);
        
        mainCamera?.addChild(endScorePanel);
        
    }
    
    @objc
    private func playerDied() {
    let highscore = GameManager.instance.getScore();
    
    if highscore < Int32(GameplayController.instance.score) {
    GameManager.instance.setScore(Int32(GameplayController.instance.score));
    }
    
    GameManager.instance.saveData();
    
    let scene = MainMenuScene(fileNamed: "MainMenu");
    scene?.scaleMode = SKSceneScaleMode.aspectFill;
    self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1));
}
    
    private func getLabels() {
        GameplayController.instance.scoreText = self.mainCamera?.childNode(withName: "Score Label") as? SKLabelNode!;
        GameplayController.instance.lifeText = self.mainCamera?.childNode(withName: "Health Label") as? SKLabelNode!;
    }
    
    func cakeCheck() {
        for child in children {
            let childName = child.name?.components(separatedBy: " ");
            
            if childName![0] == "Cake" {
                exists = true;
            } else if (childName![0] == "Enemy" || childName![0] == "BG" || childName![0] == "Player" || childName![0] == "Bullet" || childName![0] == "Health") {
                
            } else {
                exists = false;
            }
        }
    }
    
    }
    
    
    

