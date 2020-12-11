//
//  GameScene.swift
//  SpriteKitFunS1
//
//  Created by Gina Sprint on 12/7/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // a SKScene.swift file can have an associated .sks file
    // the .sks file is the graphical editor component to this file
    
    var background = SKSpriteNode()
    var spike = SKSpriteNode()
    var floor = SKSpriteNode()
    var ceiling = SKSpriteNode()
    
    var scoreLabel = SKLabelNode()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var timer: Timer? = nil
    
    enum NodeCategory: UInt32 {
        // each sprite needs a "category" that is a unique
        // power of 2, because a "mask" is computed using bitwise and-ing
        // and or-ing to determine collisions and contacts
        case spike = 1 // 0001
        case floorCeiling = 2 // 0010
        case basketball = 4 // 0100
        case football = 8 // 1000
    }
    
    override func didMove(to view: SKView) {
        // recall a SKView can show one or more SKScenes
        // this method is like viewDidLoad()
        // its called when the view "moves to" this scene
        // put our init code in here
        
        self.physicsWorld.contactDelegate = self
        
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
        spike.physicsBody?.categoryBitMask = NodeCategory.spike.rawValue
        // spike can come into contact with basketballs and footballs
        spike.physicsBody?.contactTestBitMask = NodeCategory.basketball.rawValue | NodeCategory.football.rawValue
        // spike can collide with the floor and the ceiling
        spike.physicsBody?.collisionBitMask = NodeCategory.floorCeiling.rawValue
        addChild(spike)
        
        // we need a "floor" so spike doesn't fall to oblivion
        floor = SKSpriteNode(color: .blue, size: CGSize(width: self.frame.width, height: 100.0))
        floor.position = CGPoint(x: self.frame.midX, y: self.frame.minY + floor.size.height / 2)
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: floor.size.width, height: floor.size.height))
        floor.physicsBody?.isDynamic = false // so our floor doesn't move
        floor.physicsBody?.categoryBitMask = NodeCategory.floorCeiling.rawValue
        addChild(floor)
        
        // we need a "ceiling"
        ceiling = SKSpriteNode(color: .blue, size: CGSize(width: self.frame.width, height: 100.0))
        ceiling.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - ceiling.size.height / 2)
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ceiling.size.width, height: ceiling.size.height))
        ceiling.physicsBody?.isDynamic = false // so our ceiling doesn't move
        ceiling.physicsBody?.categoryBitMask = NodeCategory.floorCeiling.rawValue
        addChild(ceiling)
        
        // add score label
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x: ceiling.position.x, y: ceiling.position.y - 20)
        score = 0 // force an update of the label
        addChild(scoreLabel)
        
        // task: set up a timer so that every 3 seconds we add a flying basketball
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
            self.addBall()
        })
    }

    func addBall() {
        // game plan
        // 1. create a sprite for a ball
        // 2. animate the ball so it flies across the screen right to left
        // 3. animate the ball so it rotates as it flies
        // 4. setup contacts and collisions for spike, the balls, the floor/ceiling
        // 5. add the footballs
        
        // 1. create a sprite for a ball
        let ball = SKSpriteNode(imageNamed: "basketball")
        ball.size = CGSize(width: 125, height: 125)
        // position x: ball starts off screen to the right y: random Y coordinate that is valid (e.g. doesn't overlap with floor or ceiling)
        let minRandY = Int(self.frame.minY + floor.size.height + ball.size.height / 2)
        let maxRandY = Int(self.frame.maxY - ceiling.size.height - ball.size.height / 2)
        let randY = CGFloat(Int.random(in: minRandY...maxRandY)) // TODO: fix this to be random
        ball.position = CGPoint(x: self.frame.maxX + ball.size.width / 2, y: randY)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = NodeCategory.basketball.rawValue
        ball.physicsBody?.contactTestBitMask = NodeCategory.spike.rawValue
        
        // 2. animate the ball so it flies across the screen right to left
        // use SKAction to animate a node
        let moveLeft = SKAction.move(to: CGPoint(x: self.frame.minX - ball.size.width / 2, y: randY), duration: 2)
        // then remove the ball from the scene when it is off screen
        let removeBall = SKAction.removeFromParent()
        // put the two actions together in a sequence
        let flyAnimation = SKAction.sequence([moveLeft, removeBall])
        ball.run(flyAnimation)
        
        // 3. animate the ball so it rotates as it flies
        let rotateBall = SKAction.rotate(byAngle: 2 * CGFloat.pi, duration: 1)
        let rotateBallForever = SKAction.repeatForever(rotateBall)
        ball.run(rotateBallForever)
        
        // 4. setup contacts and collisions for spike, the balls, the floor/ceiling
        // contact: when two sprites "touch" but they don't "bounce" or change according to physics
        // collision: when two sprites "touch" but they can't intersect, therefore physics needs to define what happens
        // setup delegation and a callback for contact
        
        addChild(ball)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // called when two bodies come into contact according to logical anding of bit masks
        // there are two bodies, bodyA and bodyB, no guarantee on the order
        // we need to see which one is a basketball
        if contact.bodyA.categoryBitMask == NodeCategory.basketball.rawValue || contact.bodyB.categoryBitMask == NodeCategory.basketball.rawValue {
            print("spike has contact with a basketball")
            // remove the basketball from the scene (e.g. spike "catching" the ball)
            contact.bodyA.categoryBitMask == NodeCategory.basketball.rawValue ? contact.bodyA.node?.removeFromParent() : contact.bodyB.node?.removeFromParent()
            // add a score label and add one when spike catches a ball
            score += 1
            // add footballs (task 5)
            // when spike catches a football, add game over logic
            // pause the game, invalidate the timer, show the play again sprite, when the user taps the screen, reset the game
        }
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
