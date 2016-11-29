//
//  GameScene.swift
//  FlyOrDie
//
//  Created by KBryan on 2016-02-13.
//  Copyright (c) 2016 KBryan. All rights reserved.
//

import SpriteKit


struct PhysicsCategory {
    static let birdGroup      : UInt32 =  1
    static let objectGroup       : UInt32 = 2
    static let gapGroup       : UInt32 = 0 << 3
    
}

class MainGame: SKScene , SKPhysicsContactDelegate{
    
    var playButton = SKSpriteNode()
    
    let playButtonTex = SKTexture(imageNamed: "play")
    
    var player = SKSpriteNode()
    var bg = SKSpriteNode()
    var labelHolder = SKSpriteNode()
    
    var score = 0
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    
    // display high score
    var highScoreLabal = SKLabelNode()
    
    var gameOver = 0
    var movingObjects = SKNode()
    
    
    var gapHeight:CGFloat?// = bird.size.height * 2.5
    var pipeOffset:CGFloat?// = CGFloat(movementAmount) - self.frame.height / 4
    
    
    override func didMove(to view: SKView) {
        /// Set up background
        
        makeBackground()
        self.addChild(labelHolder)
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.zPosition = 12
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height - 70)
        
        self.physicsWorld.contactDelegate = self
        //self.physicsWorld.gravity = CGVectorMake(0, -5)
        self.addChild(movingObjects)
        
        
        
        /// Create the bird
        let birdTexture = SKTexture(imageNamed: "flappy1")
        let birdTexture2 = SKTexture(imageNamed: "flappy2")
        let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        /**
        Create the animation
        
        - parameter texture: <#texture description#>
        */
        player = SKSpriteNode(texture: birdTexture)
        player.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        player.run(makeBirdFlap)
        player.zPosition = 11
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 2)
        player.physicsBody?.isDynamic = true;
        player.physicsBody?.allowsRotation = false;
        player.physicsBody?.categoryBitMask = PhysicsCategory.birdGroup
        player.physicsBody?.contactTestBitMask = PhysicsCategory.objectGroup
        player.physicsBody?.collisionBitMask = PhysicsCategory.gapGroup
        self.addChild(player)
        
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: 0)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: 1))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.objectGroup
        self.addChild(ground)
        /// draw pipes
        let timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(MainGame.makePipes), userInfo: nil, repeats: true)
        timer.fire()
        
        self.addChild(scoreLabel)
        
        
    }
    func makeBackground()
    {
        let bgTexture = SKTexture(imageNamed: "bg")
        let movebg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 9)
        let replaceBG = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
        let moveBgForever = SKAction.repeatForever(SKAction.sequence([movebg,replaceBG]))
        for i in 0...3  {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x:bgTexture.size().width / 2 + bgTexture.size().width * CGFloat(i), y: self.frame.midY)
            bg.size.height = self.frame.height
            bg.run(moveBgForever)
            movingObjects.addChild(bg)
            bg.zPosition = 0
        }
    }
    func makePipes() {
        
        if(gameOver == 0) {
            
            let gapHeight = player.size.height * 2.5
            let movementAmount = arc4random() % UInt32(self.frame.size.height / 3)
            let pipeOffset = CGFloat(movementAmount) - self.frame.height / 4
            
            let movePipes = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: TimeInterval(self.frame.size.width  / 100))
            let removePipes = SKAction.removeFromParent()
            let moveAndRemovePipes = SKAction.sequence([movePipes,removePipes])
            
            let pipe1Texture = SKTexture(imageNamed: "pipe1")
            
            let pipe1 = SKSpriteNode(texture: pipe1Texture)
            pipe1.zPosition = 10
            pipe1.physicsBody = SKPhysicsBody(rectangleOf:CGSize(width: 100, height: 900))
            pipe1.physicsBody?.isDynamic = false
            pipe1.position = CGPoint(x: self.frame.midX + self.frame.size.width, y: self.frame.midY + pipe1.size.height / 2 + gapHeight / 2 + pipeOffset)
            pipe1.run(moveAndRemovePipes)
            let action = SKAction.rotate(byAngle: CGFloat(M_PI), duration:1)
            
            pipe1.run(SKAction.repeatForever(action))
            pipe1.physicsBody?.categoryBitMask = PhysicsCategory.objectGroup
            movingObjects.addChild(pipe1)
            
            let pipe2Texture = SKTexture(imageNamed: "pipe2")
            
            let pipe2 = SKSpriteNode(texture: pipe2Texture)
            pipe2.zPosition = 10
            pipe2.physicsBody?.affectedByGravity = false
            pipe2.physicsBody = SKPhysicsBody(rectangleOf:CGSize(width: 100, height: 900))
            pipe2.physicsBody?.isDynamic = false
            let action1 = SKAction.rotate(byAngle: CGFloat(M_PI), duration:1)
            pipe2.run(SKAction.repeatForever(action1))
            pipe2.position = CGPoint(x: self.frame.midX + self.frame.size.width, y: self.frame.midY - pipe2.size.height / 2 - gapHeight / 2 + pipeOffset)
            pipe2.run(moveAndRemovePipes)
            pipe2.physicsBody?.categoryBitMask = PhysicsCategory.objectGroup
            movingObjects.addChild(pipe2)
            
            let gap = SKNode()
            gap.position = CGPoint(x: self.frame.midX + self.frame.size.width, y: self.frame.midY  + pipeOffset)
            gap.run(moveAndRemovePipes)
            gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: gapHeight))
            gap.physicsBody?.collisionBitMask = PhysicsCategory.gapGroup
            gap.physicsBody?.categoryBitMask = PhysicsCategory.gapGroup
            gap.physicsBody?.isDynamic = false
            gap.physicsBody?.contactTestBitMask = PhysicsCategory.birdGroup
            movingObjects.addChild(gap)
        }
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        print("Contact Being Made")
        
        if(contact.bodyA.categoryBitMask == PhysicsCategory.gapGroup || contact.bodyB.categoryBitMask == PhysicsCategory.gapGroup)
        {
            score += 1
            scoreLabel.text = "\(score)"
        } else {
            print("player died")
            if(gameOver == 0) {
                gameOver = 1
                movingObjects.speed = 0
                highScoreLabal.fontName = "Helvetica"
                highScoreLabal.fontSize = 25
                highScoreLabal.text = "Your current High Score is ... \(score)"
                highScoreLabal.position = CGPoint(x: self.frame.midX, y: self.frame.size.height - 70)
                highScoreLabal.zPosition = 11
                labelHolder.addChild(highScoreLabal)
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontSize = 30
                gameOverLabel.text = "Game Over, Tap To Play Again"
                gameOverLabel.zPosition = 12
                gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                labelHolder.addChild(gameOverLabel)
            }
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        //for touch in touches {
        if(gameOver == 0) {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        } else {
            
            
            let nextScene = GameScene(size: scene!.size)
            nextScene.scaleMode = .aspectFill
            
            scene?.view?.presentScene(nextScene)
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
