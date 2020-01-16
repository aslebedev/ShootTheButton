//
//  GameScene.swift
//  ShootTheButton
//
//  Created by alexander on 16.01.2020.
//  Copyright © 2020 alexander. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var bullet: SKSpriteNode!
    
    var lastLocation: CGPoint?
    var newLocation: CGPoint?
    
    let enemies = ["square", "quick"]
    let rows = [1, 2, 3]
    
    var gameTimer: Timer?
    
    var velocityMultiplier = 1.0
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.png")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        player = SKSpriteNode(imageNamed: "player.png")
        player.position = CGPoint(x: 512, y: 26)
        addChild(player)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        player.position = touch.location(in: self)
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        var location = touch.location(in: self)
//
//        if let lastLocation = lastLocation, let newLocation = newLocation {
//            location.x = location.x - (newLocation.x - lastLocation.x)
//        }
//
//        if location.x < 80 {
//            location.x = 80
//        } else if location.x > 944 {
//            location.x = 944
//        }
//
//        player.position = CGPoint(x: location.x, y: 26)
//    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        lastLocation = player.position
//    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 || node.position.x > 1324  {
                node.removeFromParent()
            }
        }
    }

    @objc func createEnemy() {
        guard let enemy = enemies.randomElement() else { return }
        guard let row = rows.randomElement() else { return }

        var enemyLocation = CGPoint(x: 0, y: 0)
        var velocity = CGVector(dx: 0, dy: 0)

        switch row {
        case 1:
            enemyLocation = CGPoint(x: 100, y: Int.random(in: 200...300))
            velocity = CGVector(dx: 500, dy: 0)
        case 2:
            enemyLocation = CGPoint(x: 924, y: Int.random(in: 400...500))
            velocity = CGVector(dx: -500, dy: 0)
        case 3:
            enemyLocation = CGPoint(x: 100, y: Int.random(in: 600...700))
            velocity = CGVector(dx: 500, dy: 0)
        default:
            enemyLocation = CGPoint(x: 100, y: Int.random(in: 600...700))
        }

        if enemy == "quick" {
            velocity.dx *= 1.2
        }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = enemyLocation
        addChild(sprite)

        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.velocity = velocity
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        sprite.physicsBody?.categoryBitMask = 1
    }
}


/*
import GameplayKit
 
class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
*/
