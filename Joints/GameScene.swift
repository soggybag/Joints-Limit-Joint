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
    
    
    
    
    func createChain() {
        var pos = boxA.position
        pos.x += 10
        var links = [SKSpriteNode]()
        
        for i in 0..<10 {
            let color = UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 0.3)
            let linkSize = CGSize(width: 20, height: 8)
            let link = SKSpriteNode(color: color, size: linkSize)
            link.physicsBody = SKPhysicsBody(rectangleOfSize: linkSize)
            link.physicsBody?.categoryBitMask = 0
            link.physicsBody?.collisionBitMask = 0
            
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
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: view.frame)
        physicsBody?.categoryBitMask = 1
        physicsBody?.collisionBitMask = 1
        
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
        
        boxA.physicsBody?.categoryBitMask = 1
        boxA.physicsBody?.collisionBitMask = 1
        
        boxB.physicsBody?.categoryBitMask = 1
        boxB.physicsBody?.collisionBitMask = 1
        
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






