//
//  GameScene.swift
//  Isometry
//
//  Created by Jeffrey Rosenbluth on 9/19/18.
//  Copyright © 2018 Applause Code. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Sprite {
    var sprite: SKSpriteNode
    var scale: CGFloat
    var angle: CGFloat
    func run(_ act: SKAction) -> Void {
        sprite.run(act)
    }
}


class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var broncoNode : SKSpriteNode?
    private var node : SKSpriteNode?
    private var a = CGFloat.pi / 4
    private let scale : CGFloat = 1
    
    private var compass = Sprite(sprite: SKSpriteNode(), scale: 0.67, angle: 0)
    
    // Rotate a sprite by theta keeping track of the cummulative rotation of the sprite.
    func rotate(node: inout Sprite, theta: CGFloat, duration: Double) -> SKAction {
        // We must record the total amount of rotation since sprite kit will reflect
        // about the rotated x-axis when we scale y by -1.
        node.angle = remainder(theta + node.angle, 2 * CGFloat.pi)
        return SKAction.rotate(byAngle: theta, duration: duration)
    }
    
    // Reflect a sprite about the line at angle theta with the x-axis.
    func reflect(node: inout Sprite, theta: CGFloat, duration: Double) -> SKAction {
        let s = node.sprite.yScale
        let ref = SKAction.scaleY(to: -1 * s, duration: duration)
        // Since the only reflection we can use is scaleY = -1 which reflects about
        // the transformed x-axis we calculate the rotation so that when it is composed
        // with the fixed reflectioj gives a new reflection about theta.
        let psi = 2 * (theta - node.angle)
        let rot = rotate(node: &node, theta: psi, duration: duration)
 
        return SKAction.sequence([ref, rot])
    }
    
    override func didMove(to view: SKView) {
        self.broncoNode = SKSpriteNode(imageNamed: "compass")
        guard let node = self.broncoNode else { return }
        node.setScale(scale)
        compass.sprite = node
        self.addChild(compass.sprite)
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        // leftArrow
        case 0x7B:
            compass.run(rotate(node: &compass, theta: a, duration: 1))
        // rightArrow
        case 0x7C:
            compass.run(rotate(node: &compass, theta: -a, duration: 1))
        // downArrow
        case 0x7D:
            compass.run(SKAction.scaleY(to: -1 * compass.sprite.yScale, duration: 1))
        // upArrow
        case 0x7E:
            compass.run(reflect(node: &compass, theta: a, duration: 1))
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
