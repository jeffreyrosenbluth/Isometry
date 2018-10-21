//
//  GameScene.swift
//  Isometry
//
//  Created by Jeffrey Rosenbluth on 9/19/18.
//  Copyright © 2018 Applause Code. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var broncoNode : SKSpriteNode?
    private var node : SKSpriteNode?
    private let scale : CGFloat = 1
    
    var compass = Sprite("F")
    
    func stamp() {
        if compass.sprite.hasActions() { return }
        let s = compass.sprite.copy() as! SKLabelNode
        s.fontColor = SKColor.gray
        s.zPosition = -1
        self.addChild(s)
    }

    override func didMove(to view: SKView) {
        self.addChild(compass.sprite)
        let dot = SKShapeNode(circleOfRadius: 2)
        dot.fillColor = NSColor.orange
        dot.strokeColor = NSColor.orange
        compass.sprite.addChild(dot)
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        // r
        case 0x0F:
            stamp()
            let sceneViewController = self.view?.window?.contentViewController as! ViewController
            let x = CGFloat(sceneViewController.rotateX.doubleValue)
            let y = CGFloat(sceneViewController.rotateY.doubleValue)
            let a = CGFloat(sceneViewController.rotateTheta.doubleValue) * CGFloat.pi * 2 / 360
            compass.run(compass.rotate(point: CGPoint(x: x, y: y), theta: a, duration: 1))
        // t
        case 0x11:
            stamp()
            let sceneViewController = self.view?.window?.contentViewController as! ViewController
            let x = CGFloat(sceneViewController.translateX.doubleValue)
            let y = CGFloat(sceneViewController.translateY.doubleValue)
            compass.run(compass.translate(point: CGPoint(x: x, y: y), duration: 1))
        // f
        case 0x03:
            stamp()
            let sceneViewController = self.view?.window?.contentViewController as! ViewController
            let m = CGFloat(sceneViewController.reflectMid.doubleValue)
            let a = CGFloat(sceneViewController.reflectTheta.doubleValue) * CGFloat.pi * 2 / 360
            compass.run(compass.reflect(mid: m, theta: a, duration: 1))
        // g
        case 0x05:
            stamp()
            let sceneViewController = self.view?.window?.contentViewController as! ViewController
            let x = CGFloat(sceneViewController.glideX.doubleValue)
            let y = CGFloat(sceneViewController.glideY.doubleValue)
            let a = CGFloat(sceneViewController.glideTheta.doubleValue) * CGFloat.pi * 2 / 360
            compass.run(compass.glide(v: CGPoint(x: x, y: y), theta: a, duration: 1))
        // Command-K
        case 0x28:
            self.removeAllChildren()
            compass = Sprite("F")
            self.addChild(compass.sprite)
            let dot = SKShapeNode(circleOfRadius: 3)
            dot.fillColor = NSColor.red
            dot.strokeColor = NSColor.red
            compass.sprite.addChild(dot)
        default:
            break
        }
    }
        
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
