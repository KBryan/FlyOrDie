import SpriteKit





class GameScene: SKScene {
    
    
    
    let playButtonTex = SKTexture(imageNamed: "play")
    var backgroundNode = SKSpriteNode()
    let bgTexture = SKTexture(imageNamed: "bg")
    var playButton = SKSpriteNode()
    
    
    var  testArray = [0,0,0]
    
    
    override func didMove(to view: SKView) {

        makeBackground()
        makePlayButton(playButtonTex)
    }
    /**
     Makes and displays background and animation
     */
    func makeBackground()
    {
        
        let bgTexture = SKTexture(imageNamed: "bg")
        let movebg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 9)
        let replaceBG = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
        let moveBgForever = SKAction.repeatForever(SKAction.sequence([movebg,replaceBG]))
        for i in 0...3 {
            backgroundNode = SKSpriteNode(texture: bgTexture)
            backgroundNode.position = CGPoint(x:bgTexture.size().width / 2 + bgTexture.size().width * CGFloat(i), y: self.frame.midY)
            backgroundNode.size.height = self.frame.height
            backgroundNode.run(moveBgForever)
            self.addChild(backgroundNode)
            backgroundNode.zPosition = 0
        }
       
    }
    func makePlayButton(_ textureToLoad:SKTexture) {
        playButton = SKSpriteNode(texture: textureToLoad)
        playButton.name = "playButtonTex"
        playButton.zPosition = 9
        playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(playButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "playButtonTex" {
                
                let nextScene = MainGame(size: scene!.size)
                nextScene.scaleMode = .aspectFill
                
                scene?.view?.presentScene(nextScene)
                self.removeChildren(in: [playButton])
            }
        }
    }
    
}
