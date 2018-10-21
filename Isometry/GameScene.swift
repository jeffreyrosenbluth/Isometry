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
    
    private let dot = SKShapeNode(circleOfRadius: 2)
    var compass = Sprite("L")
    
    
    func stamp() {
        if compass.sprite.hasActions() { return }
        let s = compass.sprite.copy() as! SKLabelNode
        s.fontColor = SKColor.gray
        s.zPosition = -1
        self.addChild(s)
    }

    override func didMove(to view: SKView) {
        self.addChild(compass.sprite)
        dot.fillColor = NSColor.yellow
        dot.strokeColor = NSColor.yellow
        self.addChild(dot)
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        // r
        case 0x0F:
            stamp()
            let sceneViewController = self.view?.window?.contentViewController as! ViewController
            let x = CGFloat(sceneViewController.rotateX.doubleValue)
            let y = CGFloat(sceneViewController.rotateY.doubleValue)
            var a = CGFloat(sceneViewController.rotateTheta.doubleValue) * CGFloat.pi * 2 / 360
            if event.modifierFlags.contains(.shift) { a = -a }
            compass.doRotate(point: CGPoint(x: x, y: y), theta: a, duration: 1)
        // t
        case 0x11:
            stamp()
            let sceneViewController = self.view?.window?.contentViewController as! ViewController
            var x = CGFloat(sceneViewController.translateX.doubleValue)
            var y = CGFloat(sceneViewController.translateY.doubleValue)
            if event.modifierFlags.contains(.shift) {
                x = -x
                y = -y
            }
            compass.doTranslate(point: CGPoint(x: x, y: y), duration: 1)
        // f
        case 0x03:
            stamp()
            let sceneViewController = self.view?.window?.contentViewController as! ViewController
            let m = CGFloat(sceneViewController.reflectMid.doubleValue)
            var a = CGFloat(sceneViewController.reflectTheta.doubleValue) * CGFloat.pi * 2 / 360
            if event.modifierFlags.contains(.shift) { a = -a }
            compass.doReflect(mid: m, theta: a, duration: 1)
        // g
        case 0x05:
            stamp()
            let sceneViewController = self.view?.window?.contentViewController as! ViewController
            let x = CGFloat(sceneViewController.glideX.doubleValue)
            let y = CGFloat(sceneViewController.glideY.doubleValue)
            var a = CGFloat(sceneViewController.glideTheta.doubleValue) * CGFloat.pi * 2 / 360
            if event.modifierFlags.contains(.shift) { a = -a }
            compass.doGlide(v: CGPoint(x: x, y: y), theta: a, duration: 1)
        // Command-K
        case 0x28:
            self.removeAllChildren()
            compass = Sprite("L")
            self.addChild(compass.sprite)
            self.addChild(dot)
        default:
            print(event.keyCode)
            break
        }
    }
        
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
