//
//  ViewController.swift
//  Isometry
//
//  Created by Jeffrey Rosenbluth on 9/19/18.
//  Copyright © 2018 Applause Code. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    @IBOutlet weak var expression: NSTextField!
    @IBOutlet weak var translateY: NSTextField!
    @IBOutlet weak var translateX: NSTextField!
    @IBOutlet weak var rotateY: NSTextField!
    @IBOutlet weak var rotateX: NSTextField!
    @IBOutlet weak var rotateTheta: NSTextField!
    @IBOutlet weak var reflectMid: NSTextField!
    @IBOutlet weak var reflectTheta: NSTextField!
    @IBOutlet weak var glideX: NSTextField!
    @IBOutlet weak var glideY: NSTextField!
    @IBOutlet weak var glideTheta: NSTextField!
    
    private var scene: GameScene = GameScene()
    
    @IBAction func go(_ sender: NSButton) {
        var s = scene.compass
        scene.stamp()
        s.run(s.rotate(theta: CGFloat.pi / 2, duration: 1))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateX.doubleValue = 50
        translateY.doubleValue = 50
        rotateX.doubleValue = 0
        rotateY.doubleValue = 0
        rotateTheta.doubleValue = 45
        reflectMid.doubleValue = 0
        reflectTheta.doubleValue = 45
        glideX.doubleValue = 100
        glideY.doubleValue = 50
        glideTheta.doubleValue = 180
        
        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            scene = SKScene(fileNamed: "GameScene") as! GameScene
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            scene.backgroundColor = .lightGray
            
            // Present the scene
            view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

