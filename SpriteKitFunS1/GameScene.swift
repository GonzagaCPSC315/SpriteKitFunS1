//
//  GameScene.swift
//  SpriteKitFunS1
//
//  Created by Gina Sprint on 12/7/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // a SKScene.swift file can have an associated .sks file
    // the .sks file is the graphical editor component to this file
    
    var background = SKSpriteNode()
    var spike = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        // recall a SKView can show one or more SKScenes
        // this method is like viewDidLoad()
        // its called when the view "moves to" this scene
        // put our init code in here
        
        // exploring our coordinate system
        print("Frame width: \(self.frame.width) height: \(self.frame.height)")
        print("minX: \(self.frame.minX) maxX: \(self.frame.maxX)")
        print("minY: \(self.frame.minY) maxY: \(self.frame.maxY)")
        print("midX: \(self.frame.midX) midY: \(self.frame.midY)")
        
        // add our background image as a sprite
        background = SKSpriteNode(imageNamed: "court")
        // set the background's size to be the same as the scene's frame
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        // we want our background to be "behind" all the other sprites
        background.zPosition = -1 // default 0
        // add the background to the scene with addChild()
        addChild(background)
        
        // add spike
        spike = SKSpriteNode(imageNamed: "spike")
        spike.size = CGSize(width: 225, height: 200)
        addChild(spike)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
