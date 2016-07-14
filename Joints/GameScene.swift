//
//  GameScene.swift
//  Joints
//
//  Created by mitchell hudson on 7/13/16.
//  Copyright (c) 2016 mitchell hudson. All rights reserved.
//



/*
 
This example sets up a set up chan links using pin joints.
 
Tapping a box will throw it in the air. Note tapping a chain link will 
 do nothing. The two boxes will stay connected via a series of smaller 
 rectangles that act as a chain. 
 
*/



import SpriteKit


struct PhysicsCategory {
    static let None: UInt32 =   0
    static let Box: UInt32 =    0b1
    static let Chain: UInt32 =  0b10
    static let Edge: UInt32 =   0b100
}


class GameScene: SKScene {
    
    var boxA: SKSpriteNode!
    var boxB: SKSpriteNode!
    
    
    
    
    func createChain() {
        var pos = boxA.position
        pos.x += 10
        var links = [SKSpriteNode]()
        
        for i in 0..<10 {
            let color = UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 0.3)
            let linkSize = CGSize(width: 20, height: 8)
            let link = SKSpriteNode(color: color, size: linkSize)
            link.physicsBody = SKPhysicsBody(rectangleOfSize: linkSize)
            
            link.physicsBody?.linearDamping = 0.2
            
            link.physicsBody?.categoryBitMask = PhysicsCategory.Chain
            link.physicsBody?.collisionBitMask = PhysicsCategory.Edge
            
            addChild(link)
            link.position = pos
            pos.x += 20
            
            links.append(link)
        }
        
        for i in 0..<links.count {
            if i == 0 {
                let pin = SKPhysicsJointPin.jointWithBodyA(boxA.physicsBody!,
                                                           bodyB: links[i].physicsBody!,
                                                           anchor: boxA.position)
                physicsWorld.addJoint(pin)
                
            } else {
                var anchor = links[i].position
                anchor.x -= 10
                let pin = SKPhysicsJointPin.jointWithBodyA(links[i - 1].physicsBody!,
                                                           bodyB: links[i].physicsBody!,
                                                           anchor: anchor)
                physicsWorld.addJoint(pin)
            }
        }
        
        let pin = SKPhysicsJointPin.jointWithBodyA(boxB.physicsBody!,
                                                   bodyB: links.last!.physicsBody!,
                                                   anchor: boxB.position)
        physicsWorld.addJoint(pin)
        
    }
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: view.frame)
        physicsBody?.categoryBitMask = PhysicsCategory.Edge
        physicsBody?.collisionBitMask = PhysicsCategory.Chain
        
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
        
        boxA.physicsBody?.linearDamping = 0.2
        boxB.physicsBody?.linearDamping = 0.2
        
        boxA.physicsBody?.categoryBitMask = PhysicsCategory.Box
        boxA.physicsBody?.collisionBitMask = PhysicsCategory.Box | PhysicsCategory.Edge
        
        boxB.physicsBody?.categoryBitMask = PhysicsCategory.Box
        boxB.physicsBody?.collisionBitMask = PhysicsCategory.Box | PhysicsCategory.Edge
        
        boxA.name = "box"
        boxB.name = "box"
        
        createChain()
        
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
        
        
    }
}






