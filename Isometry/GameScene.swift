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
    var position: CGPoint
    
    func run(_ act: SKAction) -> Void {
        sprite.run(act)
    }
    
    func flip(duration: Double) -> SKAction {
        return SKAction.scaleY(to: -1 * sprite.yScale, duration: duration)
    }
    
    // Rotate a sprite by theta keeping track of the cummulative rotation of the sprite.
    mutating func rotate(theta: CGFloat, duration: Double) -> SKAction {
        // We must record the total amount of rotation since sprite kit will reflect
        // about the rotated x-axis when we scale y by -1.
        angle = remainder(theta + angle, 2 * CGFloat.pi)
        return SKAction.rotate(byAngle: theta, duration: duration)
    }
    
    mutating func rotate(point: CGPoint, theta: CGFloat, duration: Double) -> SKAction {
        angle = remainder(theta + angle, 2 * CGFloat.pi)
        let p = CGPoint(x: position.x - point.x , y: position.y - point.y).applying(CGAffineTransform.init(rotationAngle: theta))
        let r = rotate(theta: theta, duration: duration)
        let t = translate(x: p.x + point.x - position.x, y: p.y + point.y - position.y, duration: duration)
        return SKAction.group([r,t])
    }
    
    // Reflect a sprite about the line at angle theta with the x-axis.
    mutating func reflect(theta: CGFloat, duration: Double) -> SKAction {
        let ref = flip(duration: duration)
        // Since the only reflection we can use is scaleY = -1 which reflects about
        // the transformed x-axis we calculate the rotation so that when it is composed
        // with the fixed reflectioj gives a new reflection about theta.
        let psi = 2 * (theta - angle)
        let rot = rotate(theta: psi, duration: duration)
        return SKAction.group([ref, rot])
    }
    
    mutating func translate(x: CGFloat, y: CGFloat, duration: Double) -> SKAction {
        position.x = position.x + x
        position.y = position.y + y
        return SKAction.moveBy(x: x, y: y, duration: duration)
    }
}


class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var broncoNode : SKSpriteNode?
    private var node : SKSpriteNode?
    private var a = CGFloat.pi / 4
    private let scale : CGFloat = 1
    
    private var compass = Sprite(sprite: SKSpriteNode(), scale: 0.67, angle: 0, position: CGPoint())
    

    override func didMove(to view: SKView) {
        self.broncoNode = SKSpriteNode(imageNamed: "Navigation")
        guard let node = self.broncoNode else { return }
        node.setScale(scale)
        compass.sprite = node
        self.addChild(compass.sprite)
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        // leftArrow
        case 0x7B:
            compass.run(compass.rotate(theta: a, duration: 1))
//            compass.run(rotate(node: &compass, theta: a, duration: 1))
        // rightArrow
        case 0x7C:
            compass.run(compass.rotate(theta: -a, duration: 1))
        // downArrow
        case 0x7D:
            compass.run(SKAction.scaleY(to: -1 * compass.sprite.yScale, duration: 1))
        // upArrow
        case 0x7E:
            compass.run(compass.reflect(theta: a, duration: 1))
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        let p = event.location(in: self)
        compass.run(compass.rotate(point: CGPoint(x: p.x, y: p.y), theta: a, duration: 1))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
