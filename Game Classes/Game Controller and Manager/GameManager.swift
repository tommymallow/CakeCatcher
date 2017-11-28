//
//  GameManager.swift
//  Scum
//
//  Created by Tommy Mallow on 11/17/17.
//  Copyright © 2017 Marshmallow. All rights reserved.
//

import Foundation

class GameManager {
    
    static let instance = GameManager();
    fileprivate init() {}
    
    fileprivate var gameData: GameData?;
    
    func initializeGameData() {
        
        if !FileManager.default.fileExists(atPath: getFilePath() as String) {
            // setup our game with initial values
            gameData = GameData();
            
            gameData?.setScore(0);
            
            gameData?.setIsMusicOn(false);
            
            saveData();
        }
        
        loadData();
        
    }
    
    func loadData() {
        gameData = NSKeyedUnarchiver.unarchiveObject(withFile: getFilePath() as String) as? GameData!
    }
    
    func saveData() {
        if gameData != nil {
            NSKeyedArchiver.archiveRootObject(gameData!, toFile: getFilePath() as String);
        }
    }
    
    fileprivate func getFilePath() -> String {
        let manager = FileManager.default;
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first as URL!;
        return url!.appendingPathComponent("Game Data").path;
    }
    
    func setScore(_ Score: Int32) {
        gameData!.setScore(Score);
    }
    
    func getScore() -> Int32 {
        return gameData!.getScore();
    }
    
    func setIsMusicOn(_ isMusicOn: Bool) {
        gameData!.setIsMusicOn(isMusicOn);
    }
    
    func getIsMusicOn() -> Bool {
        return gameData!.getIsMusicOn();
    }
    
}
