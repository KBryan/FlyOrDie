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
    
    
    override func didMoveToView(view: SKView) {
        /// Set up background
        
        makeBackground()
        self.addChild(labelHolder)
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.zPosition = 12
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
        
        self.physicsWorld.contactDelegate = self
        //self.physicsWorld.gravity = CGVectorMake(0, -5)
        self.addChild(movingObjects)
        
        
        
        /// Create the bird
        let birdTexture = SKTexture(imageNamed: "flappy1")
        let birdTexture2 = SKTexture(imageNamed: "flappy2")
        let animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatActionForever(animation)
        
        /**
        Create the animation
        
        - parameter texture: <#texture description#>
        */
        player = SKSpriteNode(texture: birdTexture)
        player.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        player.runAction(makeBirdFlap)
        player.zPosition = 11
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 2)
        player.physicsBody?.dynamic = true;
        player.physicsBody?.allowsRotation = false;
        player.physicsBody?.categoryBitMask = PhysicsCategory.birdGroup
        player.physicsBody?.contactTestBitMask = PhysicsCategory.objectGroup
        player.physicsBody?.collisionBitMask = PhysicsCategory.gapGroup
        self.addChild(player)
        
        let ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.objectGroup
        self.addChild(ground)
        /// draw pipes
        let timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
        timer.fire()
        
        self.addChild(scoreLabel)
        
        
    }
    func makeBackground()
    {
        let bgTexture = SKTexture(imageNamed: "bg")
        let movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        let replaceBG = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        let moveBgForever = SKAction.repeatActionForever(SKAction.sequence([movebg,replaceBG]))
        for var i:CGFloat=0;i < 3; i++ {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x:bgTexture.size().width / 2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            bg.runAction(moveBgForever)
            movingObjects.addChild(bg)
            bg.zPosition = 0
        }
    }
    func makePipes() {
        
        if(gameOver == 0) {
            
            let gapHeight = player.size.height * 2.5
            let movementAmount = arc4random() % UInt32(self.frame.size.height / 3)
            let pipeOffset = CGFloat(movementAmount) - self.frame.height / 4
            
            let movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width  / 100))
            let removePipes = SKAction.removeFromParent()
            let moveAndRemovePipes = SKAction.sequence([movePipes,removePipes])
            
            let pipe1Texture = SKTexture(imageNamed: "pipe1")
            
            let pipe1 = SKSpriteNode(texture: pipe1Texture)
            pipe1.zPosition = 10
            pipe1.physicsBody = SKPhysicsBody(rectangleOfSize:CGSizeMake(100, 900))
            pipe1.physicsBody?.dynamic = false
            pipe1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipe1.size.height / 2 + gapHeight / 2 + pipeOffset)
            pipe1.runAction(moveAndRemovePipes)
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            pipe1.runAction(SKAction.repeatActionForever(action))
            pipe1.physicsBody?.categoryBitMask = PhysicsCategory.objectGroup
            movingObjects.addChild(pipe1)
            
            let pipe2Texture = SKTexture(imageNamed: "pipe2")
            
            let pipe2 = SKSpriteNode(texture: pipe2Texture)
            pipe2.zPosition = 10
            pipe2.physicsBody?.affectedByGravity = false
            pipe2.physicsBody = SKPhysicsBody(rectangleOfSize:CGSizeMake(100, 900))
            pipe2.physicsBody?.dynamic = false
            let action1 = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            pipe2.runAction(SKAction.repeatActionForever(action1))
            pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipe2.size.height / 2 - gapHeight / 2 + pipeOffset)
            pipe2.runAction(moveAndRemovePipes)
            pipe2.physicsBody?.categoryBitMask = PhysicsCategory.objectGroup
            movingObjects.addChild(pipe2)
            
            let gap = SKNode()
            gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame)  + pipeOffset)
            gap.runAction(moveAndRemovePipes)
            gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(1, gapHeight))
            gap.physicsBody?.collisionBitMask = PhysicsCategory.gapGroup
            gap.physicsBody?.categoryBitMask = PhysicsCategory.gapGroup
            gap.physicsBody?.dynamic = false
            gap.physicsBody?.contactTestBitMask = PhysicsCategory.birdGroup
            movingObjects.addChild(gap)
        }
        
    }
    func didBeginContact(contact: SKPhysicsContact) {
        print("Contact Being Made")
        
        if(contact.bodyA.categoryBitMask == PhysicsCategory.gapGroup || contact.bodyB.categoryBitMask == PhysicsCategory.gapGroup)
        {
            score++
            scoreLabel.text = "\(score)"
        } else {
            print("player died")
            if(gameOver == 0) {
                gameOver = 1
                movingObjects.speed = 0
                highScoreLabal.fontName = "Helvetica"
                highScoreLabal.fontSize = 25
                highScoreLabal.text = "Your current High Score is ... \(score)"
                highScoreLabal.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
                highScoreLabal.zPosition = 11
                labelHolder.addChild(highScoreLabal)
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontSize = 30
                gameOverLabel.text = "Game Over, Tap To Play Again"
                gameOverLabel.zPosition = 12
                gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                labelHolder.addChild(gameOverLabel)
            }
        }
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        //for touch in touches {
        if(gameOver == 0) {
            player.physicsBody?.velocity = CGVectorMake(0, 0)
            player.physicsBody?.applyImpulse(CGVectorMake(0, 50))
        } else {
            
            playButton = SKSpriteNode(texture: playButtonTex)
            playButton.name = "playButtonTex"
            
            
            playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            
            
            self.addChild(playButton)
            
            score = 0
            scoreLabel.text = "0"
            movingObjects.removeAllChildren()
            labelHolder.removeAllChildren()
            player.physicsBody?.velocity = CGVectorMake(0, 0)
            player.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
            gameOver = 0
            movingObjects.speed = 1
            
            makeBackground()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
