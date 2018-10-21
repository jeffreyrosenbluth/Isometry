//
//  Isometry.swift
//  Isometry
//
//  Created by Jeffrey Rosenbluth on 10/21/18.
//  Copyright © 2018 Applause Code. All rights reserved.
//

import SpriteKit


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
        l.fontSize = 96
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
    
    mutating func move(point: CGPoint, duration: Double) -> SKAction {
        position.x = point.x
        position.y = point.y
        return SKAction.move(to: point, duration: duration)
    }
    
    mutating func translate(point: CGPoint, duration: Double) -> SKAction {
        position.x = position.x + point.x
        position.y = position.y + point.y
        return SKAction.moveBy(x: point.x, y: point.y, duration: duration)
    }
    // Rotate a sprite by theta keeping track of the cummulative rotation of the sprite.
    mutating func rotate(point: CGPoint, theta: CGFloat, duration: Double) -> SKAction {
        // We must record the total amount of rotation since sprite kit will reflect
        // about the rotated x-axis when we scale y by -1.
        angle = normalizeAngle(theta + angle)
        let p = CGPoint(x: position.x - point.x , y: position.y - point.y).applying(CGAffineTransform.init(rotationAngle: theta))
        let r = SKAction.rotate(byAngle: normalizeAngle(theta), duration: duration)
        let q = CGPoint(x: p.x + point.x, y: p.y + point.y)
        let t = move(point: q, duration: duration)
        return SKAction.group([r, t])
    }
    
    // Reflect a sprite about the line at angle theta with the x-axis.
    mutating func reflect(theta: CGFloat, duration: Double) -> SKAction {
        let c = cos(2 * theta)
        let s = sin(2 * theta)
        let p = CGPoint(x: position.x , y: position.y).applying(CGAffineTransform.init(a: c , b: s, c: s, d: -c, tx: 0, ty: 0))
        let ref = flip(duration: duration)
        // Since the only reflection we can use is scaleY = -1 which reflects about
        // the transformed x-axis we calculate the rotation so that when it is composed
        // with the fixed reflection gives a new reflection about theta.
        let psi = 2 * (theta - angle)
        let rot = rotate(point: CGPoint.zero, theta: psi, duration: duration)
        let t = move(point: p, duration: duration)
        return SKAction.group([ref, rot, t])
    }
    
    mutating func reflect(mid: CGFloat, theta: CGFloat, duration: Double) -> SKAction {
        let p = CGPoint(x: -2 * mid * sin(theta), y: 2 * mid * cos(theta))
        let t = translate(point: p, duration: duration)
        let r = reflect(theta: theta, duration: duration)
        return SKAction.group([r, t])
    }
    
    mutating func glide(v: CGPoint, theta: CGFloat, duration: Double) -> SKAction {
        let t = translate(point: CGPoint(x: v.x, y: v.y), duration: duration)
        let r = reflect(theta: theta, duration: duration)
        return SKAction.group([r, t])
    }
}

