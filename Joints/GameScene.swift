//
//  GameScene.swift
//  Joints
//
//  Created by mitchell hudson on 7/13/16.
//  Copyright (c) 2016 mitchell hudson. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    var boxA: SKSpriteNode!
    var boxB: SKSpriteNode!
    var rope: SKPhysicsJointLimit!
    var line: SKShapeNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: view.frame)
        
        let boxSize = CGSize(width: 60, height: 60)
        boxA = SKSpriteNode(color: UIColor.orangeColor(), size: boxSize)
        boxB = SKSpriteNode(color: UIColor.greenColor(), size: boxSize)
        
        addChild(boxA)
        addChild(boxB)
        
        boxA.position.x = 100
        boxB.position.x = 300
        
        boxA.position.y = 30
        boxB.position.y = 30
        
        boxA.physicsBody = SKPhysicsBody(rectangleOfSize: boxSize)
        boxB.physicsBody = SKPhysicsBody(rectangleOfSize: boxSize)
        
        boxA.name = "box"
        boxB.name = "box"
    
        // Mark: Create Limit
        rope = SKPhysicsJointLimit.jointWithBodyA(boxA.physicsBody!,
            bodyB: boxB.physicsBody!,
            anchorA: boxA.position,
            anchorB: boxB.position)
        
        physicsWorld.addJoint(rope)
        
        line = SKShapeNode()
        addChild(line)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = nodeAtPoint(location)
            
            if node.name == "box" {
                print("Touch!")
                let vector = CGVector(dx: 0, dy: 8000)
                node.physicsBody?.applyForce(vector, atPoint: location)
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        let path = UIBezierPath()
        path.moveToPoint(boxA.position)
        path.addLineToPoint(boxB.position)
        line.path = path.CGPath
        line.lineWidth = 2
        line.strokeColor = UIColor.whiteColor()
    }
}






