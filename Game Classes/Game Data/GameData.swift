//
//  GameData.swift
//  Scum
//
//  Created by Tommy Mallow on 11/17/17.
//  Copyright © 2017 Marshmallow. All rights reserved.
//

import Foundation

class GameData: NSObject, NSCoding {
    
    struct Keys {
        static let Score = "Score";
        static let Music = "Music";
    }
    
    fileprivate var score = Int32();
    fileprivate var isMusicOn = false;
    
    override init() {}
    
    required init?(coder aDecoder: NSCoder) {
        //        super.init();
        
        self.score = aDecoder.decodeInt32(forKey: Keys.Score);
        
        self.isMusicOn = aDecoder.decodeBool(forKey: Keys.Music);
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encodeCInt(self.score, forKey: Keys.Score);
        
        aCoder.encode(self.isMusicOn, forKey: Keys.Music);
        
    }
    
    func setScore(_ Score: Int32) {
        self.score = Score;
    }
    
    func getScore() -> Int32 {
        return self.score;
    }
    
    func setIsMusicOn(_ isMusicOn: Bool) {
        self.isMusicOn = isMusicOn;
    }
    
    func getIsMusicOn() -> Bool {
        return self.isMusicOn;
    }
    
}





