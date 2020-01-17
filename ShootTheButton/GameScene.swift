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
    
    var scoreLabel: SKLabelNode!
    var timeLabel: SKLabelNode!
    var bulletsLabel: SKLabelNode!
    
    var lastLocation: CGPoint?
    var newLocation: CGPoint?
    
    let enemies = ["square", "quick"]
    var bulletsLeft = 60
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var timeLeft = 0 {
        didSet {
            timeLabel.text = "Time left: \(timeLeft)"
        }
    }
    var bulletQuantity = 0 {
        didSet {
            bulletsLabel.text = "Bullets: \(bulletQuantity)/\(bulletsLeft)"
        }
    }
    
    var enemyTimer: Timer?
    var velocityTimer: Timer?
    var gameTimer: Timer?
    
    var velocityMultiplier: CGFloat = 1.0
    
    var lastRow = 1
    
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "background.png")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Papyrus")
        scoreLabel.position = CGPoint(x: 100, y: 725)
        addChild(scoreLabel)
        
        timeLabel = SKLabelNode(fontNamed: "Papyrus")
        timeLabel.position = CGPoint(x: 512, y: 725)
        addChild(timeLabel)
        
        bulletsLabel = SKLabelNode(fontNamed: "Papyrus")
        bulletsLabel.position = CGPoint(x: 880, y: 725)
        addChild(bulletsLabel)
        
        player = SKSpriteNode(imageNamed: "player.png")
        player.position = CGPoint(x: 512, y: 26)
        addChild(player)

        score = 0
        bulletQuantity = 10
        timeLeft = 60
        
        enemyTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        velocityTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.velocityMultiplier *= 1.05
        }
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeLeft -= 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver { return }
        
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.x < 30 {
            location.x = 30
        } else if location.x > 974 {
            location.x = 974
        }
        
        player.position = CGPoint(x: location.x, y: 26)
        shoot()
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 || node.position.x > 1324 || node.position.x < -300 || node.position.y > 1000{
                node.removeFromParent()
            }
        }
        
        if timeLeft <= 0 {
            gameOver()
        }
    }

    @objc func createEnemy() {
        guard let enemy = enemies.randomElement() else { return }
        let row = Int.random(in: 1...3)

        var enemyLocation = CGPoint(x: 0, y: 0)
        var velocity = CGVector(dx: 0, dy: 0)

        switch row {
        case 1:
            enemyLocation = CGPoint(x: -100, y: Int.random(in: 190...290))
            velocity = CGVector(dx: 200, dy: 0)
        case 2:
            enemyLocation = CGPoint(x: 1124, y: Int.random(in: 390...490))
            velocity = CGVector(dx: -200, dy: 0)
        default:
            enemyLocation = CGPoint(x: -100, y: Int.random(in: 590...690))
            velocity = CGVector(dx: 200, dy: 0)
        }

        velocity = CGVector(dx: velocity.dx * velocityMultiplier, dy: 0)
        
        if enemy == "quick" {
            velocity.dx *= 1.4
        }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.name = "enemy"
        sprite.position = enemyLocation
        addChild(sprite)

        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = velocity
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    func shoot() {
        if bulletQuantity == 0 && bulletsLeft == 0 {
            gameOver()
            return
        }
        
        let bullet = SKSpriteNode(imageNamed: "bullet.png")
        bullet.name = "bullet"
        bullet.position = player.position
        addChild(bullet)

        bulletQuantity -= 1
        
        bullet.physicsBody = SKPhysicsBody(texture: bullet.texture!, size: bullet.size)
        bullet.physicsBody?.categoryBitMask = 1
        bullet.physicsBody?.contactTestBitMask = 1
        bullet.physicsBody?.velocity = CGVector(dx: 0, dy: 500)
        bullet.physicsBody?.linearDamping = 0
    }
    
    func gotHit(bullet: SKNode, enemy: SKNode) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = bullet.position
        addChild(explosion)

        bullet.removeFromParent()
        enemy.removeFromParent()
    }
    
    func reload() {
        if bulletsLeft <= 0 {
            return
        }
        
        bulletsLeft -= 10
        bulletQuantity = 10
    }
    
    func gameOver() {
        isGameOver = true
        
        enemyTimer?.invalidate()
        velocityTimer?.invalidate()
        gameTimer?.invalidate()
        
        let gameOverLabel = SKLabelNode(fontNamed: "Papyrus")
        gameOverLabel.fontSize = 60
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        addChild(gameOverLabel)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "bullet" {
            gotHit(bullet: nodeA, enemy: nodeB)
        } else if nodeB.name == "bullet" {
            gotHit(bullet: nodeB, enemy: nodeA)
        }
    }
    
}
