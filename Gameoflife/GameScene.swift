//
//  GameScene.swift
//  Gameoflife
//
//  Created by Carlos Diez on 6/22/16.
//  Copyright (c) 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var playButton: MSButtonNode!
    var pauseButton: MSButtonNode!
    var stepButton: MSButtonNode!
    var populationLabel: SKLabelNode!
    var generationLabel: SKLabelNode!
    var gridNode: Grid!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        playButton = self.childNodeWithName("playButton") as! MSButtonNode
        pauseButton = self.childNodeWithName("pauseButton") as! MSButtonNode
        stepButton = self.childNodeWithName("stepButton") as! MSButtonNode
        
        populationLabel = self.childNodeWithName("populationLabel") as! SKLabelNode
        generationLabel = self.childNodeWithName("generationLabel") as! SKLabelNode
        
        gridNode = childNodeWithName("gridNode") as! Grid
        
        stepButton.selectedHandler = {
            self.stepSimulation()
        }
        
        /* Create an SKAction based timer, 0.5 second delay */
        let delay = SKAction.waitForDuration(0.5)
        
        /* Call the stepSimulation() method to advance the simulation */
        let callMethod = SKAction.performSelector(#selector(GameScene.stepSimulation), onTarget: self)
        
        /* Create the delay,step cycle */
        let stepSequence = SKAction.sequence([delay,callMethod])
        
        /* Create an infinite simulation loop */
        let simulation = SKAction.repeatActionForever(stepSequence)
        
        /* Run simulation action */
        self.runAction(simulation)
        
        /* Default simulation to pause state */
        self.paused = true
        
        playButton.selectedHandler = {
            self.paused = false
        }
        pauseButton.selectedHandler = {
            self.paused = true
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func stepSimulation() {
        gridNode.evolve()
        
        populationLabel.text = String(gridNode.population)
        generationLabel.text = String(gridNode.generation)
    }
}
