//
//  GameScene.swift
//  Isometry
//
//  Created by Jeffrey Rosenbluth on 9/19/18.
//  Copyright © 2018 Applause Code. All rights reserved.
//

import SpriteKit
import GameplayKit

func normalizeAngle(_ theta: CGFloat) -> CGFloat {
    let psi = remainder(theta, 2 * CGFloat.pi)
    return psi <= CGFloat.pi ? psi : psi - 2 * CGFloat.pi
}

struct Sprite {
    var sprite: SKLabelNode
    var scale: CGFloat
    var angle: CGFloat
    var position: CGPoint
    
    init(_ s : String) {
        let l = SKLabelNode(fontNamed: "Semibold")
        l.text = "F"
        l.fontSize = 108
        l.fontColor = SKColor.black
        sprite = l
        scale = 1
        angle = 0
        position = CGPoint(x: 0, y: 0)
    }
    
    func run(_ act: SKAction) -> Void {
        if sprite.hasActions() { return }
        sprite.run(act)
    }
    
    mutating func reset() {
        angle = 0
        position = CGPoint(x: 0, y: 0)
        sprite.position = position
    }
    
    func flip(duration: Double) -> SKAction {
        return SKAction.scaleY(to: -1 * sprite.yScale, duration: duration)
    }
    
    mutating func translate(x: CGFloat, y: CGFloat, duration: Double) -> SKAction {
        position.x = position.x + x
        position.y = position.y + y
        return SKAction.moveBy(x: x, y: y, duration: duration)
    }
    
    // Rotate a sprite by theta keeping track of the cummulative rotation of the sprite.
    mutating func rotate(theta: CGFloat, duration: Double) -> SKAction {
        // We must record the total amount of rotation since sprite kit will reflect
        // about the rotated x-axis when we scale y by -1.
        angle = normalizeAngle(theta + angle)
        return SKAction.rotate(byAngle: normalizeAngle(theta), duration: duration)
    }
    
    mutating func rotate(point: CGPoint, theta: CGFloat, duration: Double) -> SKAction {
        angle = normalizeAngle(theta + angle)
        let p = CGPoint(x: position.x - point.x , y: position.y - point.y).applying(CGAffineTransform.init(rotationAngle: theta))
        let r = rotate(theta: theta, duration: duration)
        let t = translate(x: p.x + point.x - position.x, y: p.y + point.y - position.y, duration: duration)
        return SKAction.group([r, t])
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
 
    mutating func reflect(mid: CGFloat, theta: CGFloat, duration: Double) -> SKAction {
        let p = CGPoint(x: -2 * mid * sin(theta),y: 2 * mid * cos(theta))
        let t = translate(x: p.x, y: p.y, duration: duration)
        let r = reflect(theta: theta, duration: duration)
        return SKAction.group([r, t])
    }
    
    mutating func glide(v: CGPoint, theta: CGFloat, duration: Double) -> SKAction {
        let t = translate(x: v.x, y: v.y, duration: duration)
        let r = reflect(theta: theta, duration: duration)
        return SKAction.group([r, t])
    }
}


class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var broncoNode : SKSpriteNode?
    private var node : SKSpriteNode?
    private var a = CGFloat.pi / 4
    private let scale : CGFloat = 1
    
    private var compass = Sprite("F")
    
    func stamp() {
        if compass.sprite.hasActions() { return }
        let s = compass.sprite.copy() as! SKLabelNode
        s.fontColor = SKColor.gray
        s.zPosition = -1
        self.addChild(s)
    }

    override func didMove(to view: SKView) {
        self.addChild(compass.sprite)
        let dot = SKShapeNode(circleOfRadius: 3)
        dot.fillColor = NSColor.red
        dot.strokeColor = NSColor.red
        compass.sprite.addChild(dot)
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        // leftArrow
        case 0x7B:
            stamp()
            compass.run(compass.rotate(theta: a, duration: 1))
        // rightArrow
        case 0x7C:
            stamp()
            compass.run(compass.rotate(theta: -a, duration: 1))
        // downArrow
        case 0x7D:
            stamp()
            compass.run(SKAction.scaleY(to: -1 * compass.sprite.yScale, duration: 1))
        // upArrow
        case 0x7E:
            stamp()
            compass.run(compass.reflect(theta: a, duration: 1))
        // space
        case 0x31:
            stamp()
            compass.run(compass.glide(v: CGPoint(x: 100, y: 50), theta: CGFloat.pi, duration: 1))
        default:
            self.removeAllChildren()
            compass = Sprite("F")
            self.addChild(compass.sprite)
            let dot = SKShapeNode(circleOfRadius: 3)
            dot.fillColor = NSColor.red
            dot.strokeColor = NSColor.red
            compass.sprite.addChild(dot)
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        stamp()
        let p = event.location(in: self)
        compass.run(compass.rotate(point: CGPoint(x: p.x, y: p.y), theta: a, duration: 1))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
