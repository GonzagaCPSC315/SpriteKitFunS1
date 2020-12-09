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
    var floor = SKSpriteNode()
    var ceiling = SKSpriteNode()
    
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
        // we want spike to "fall" according to "gravity"
        // our scene already has a "physics world"
        // spike and other nodes need a physics body that other nodes's physics bodies interact it
        spike.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(spike.size.height / 2))
        addChild(spike)
        
        // we need a "floor" so spike doesn't fall to oblivion
        floor = SKSpriteNode(color: .blue, size: CGSize(width: self.frame.width, height: 100.0))
        floor.position = CGPoint(x: self.frame.midX, y: self.frame.minY + floor.size.height / 2)
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: floor.size.width, height: floor.size.height))
        floor.physicsBody?.isDynamic = false // so our floor doesn't move
        addChild(floor)
        
        // we need a "ceiling"
        ceiling = SKSpriteNode(color: .blue, size: CGSize(width: self.frame.width, height: 100.0))
        ceiling.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - ceiling.size.height / 2)
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ceiling.size.width, height: ceiling.size.height))
        ceiling.physicsBody?.isDynamic = false // so our ceiling doesn't move
        addChild(ceiling)
        
        // task: set up a timer so that every 3 seconds we add a flying basketball
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // when the user taps the screen, apply an impulse to send spike up
        spike.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
        // task: add a ceiling so spike cannot fly off the top of the screen
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
