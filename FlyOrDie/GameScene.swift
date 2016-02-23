import SpriteKit





class GameScene: SKScene {
    
    
    
    let playButtonTex = SKTexture(imageNamed: "play")
    var backgroundNode = SKSpriteNode()
    let bgTexture = SKTexture(imageNamed: "bg")
    var playButton = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {

        makeBackground()
        makePlayButton(playButtonTex)
    }
    /**
     Makes and displays background and animation
     */
    func makeBackground()
    {
        
        let bgTexture = SKTexture(imageNamed: "bg")
        let movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        let replaceBG = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        let moveBgForever = SKAction.repeatActionForever(SKAction.sequence([movebg,replaceBG]))
        for var i:CGFloat=0;i < 3; i++ {
            backgroundNode = SKSpriteNode(texture: bgTexture)
            backgroundNode.position = CGPoint(x:bgTexture.size().width / 2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            backgroundNode.size.height = self.frame.height
            backgroundNode.runAction(moveBgForever)
            self.addChild(backgroundNode)
            backgroundNode.zPosition = 0
        }
       
    }
    func makePlayButton(textureToLoad:SKTexture) {
        playButton = SKSpriteNode(texture: textureToLoad)
        playButton.name = "playButtonTex"
        playButton.zPosition = 9
        playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(playButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode.name == "playButtonTex" {
                
                let nextScene = MainGame(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                
                scene?.view?.presentScene(nextScene)
                self.removeChildrenInArray([playButton])
            }
        }
    }
    
}