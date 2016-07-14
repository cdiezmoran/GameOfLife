import SpriteKit

class Grid: SKSpriteNode {
    /* Grid array dimensions */
    let rows = 8
    let columns = 10
    
    /* Individual cell dimension, calculated in setup*/
    var cellWidth = 0
    var cellHeight = 0
    
    var gridArray = [[Creature]]()
    
    var population = 0;
    var generation = 0;
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        /* There will only be one touch as multi touch is not enabled by default */
        for touch in touches {
            
            /* Grab position of touch relative to the grid */
            let location  = touch.locationInNode(self)
            
            /* Calculate grid array position */
            let gridX = Int(location.x) / cellWidth
            let gridY = Int(location.y) / cellHeight
            
            /* Toggle creature visibility */
            let creature = gridArray[gridX][gridY]
            creature.isAlive = !creature.isAlive
        }
    }
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /* Enable own touch implementation for this node */
        userInteractionEnabled = true
        
        /* Calculate individual cell dimensions */
        cellWidth = Int(size.width) / columns
        cellHeight = Int(size.height) / rows
        
        populateGrid()
    }
    
    func populateGrid() {
        /* Populate the grid with creatures */
        
        /* Loop through columns */
        for gridX in 0..<columns {
            
            /* Initialize empty column */
            gridArray.append([])
            
            /* Loop through rows */
            for gridY in 0..<rows {
                
                /* Create a new creature at row / column position */
                addCreatureAtGrid(x:gridX, y:gridY)
            }
        }
    }
    
    func addCreatureAtGrid(x x: Int, y: Int) {
        let creature = Creature()
        
        let gridPosition = CGPoint(x: x * cellWidth, y: y * cellHeight)
        creature.position = gridPosition
        
        creature.isAlive = false
        
        addChild(creature)
        
        gridArray[x].append(creature)
    }
    
    func countNeighbors() {
        for gridX in 0..<columns {
            for gridY in 0..<rows {
                let currentCreature = gridArray[gridX][gridY]
                currentCreature.neighborCount = 0
                
                for innerGridX in (gridX - 1)...(gridX + 1) {
                    
                    /* Ensure inner grid column is inside array */
                    if innerGridX<0 || innerGridX >= columns { continue }
                    
                    for innerGridY in (gridY - 1)...(gridY + 1) {
                        
                        /* Ensure inner grid row is inside array */
                        if innerGridY<0 || innerGridY >= rows { continue }
                        
                        /* Creature can't count itself as a neighbor */
                        if innerGridX == gridX && innerGridY == gridY { continue }
                        
                        /* Grab adjacent creature reference */
                        let adjacentCreature:Creature = gridArray[innerGridX][innerGridY]
                        
                        /* Only interested in living creatures */
                        if adjacentCreature.isAlive {
                            currentCreature.neighborCount += 1
                        }  
                    }
                }
            }
        }
    }
    
    func updateCreatures() {
        population = 0
        
        for gridX in 0..<columns {
            for gridY in 0..<rows {
                let currentCreature = gridArray[gridX][gridY]
                
                switch currentCreature.neighborCount {
                case 3:
                    currentCreature.isAlive = true
                case 0...1, 4...8:
                    currentCreature.isAlive = false
                default:
                    break;
                }
                
                if currentCreature.isAlive { population += 1 }
            }
        }
    }
    
    func evolve() {
        /* Updated the grid to the next state in the game of life */
        
        /* Update all creature neighbor counts */
        countNeighbors()
        
        /* Calculate all creatures alive or dead */
        updateCreatures()
        
        /* Increment generation counter */
        generation += 1
    }
}