//
//  ViewController.swift
//  Hack17
//
//  Created by Женя Баян on 05/10/2018.
//  Copyright © 2018 Женя Баян. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var first: Bool = false
    
    var node: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [.showPhysicsShapes]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @objc
    func didTap(_ gesture: UIGestureRecognizer) {
        if !first {
            if let node = findNode() {
                
//                let tapLocation = gesture.location(in: sceneView)
//                let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
//                
//                guard let hitTestResult = hitTestResults.first else { return }
//                let translation = hitTestResult.worldTransform.
//                let x = translation.x
//                let y = translation.y
//                let z = translation.z
//                
//                guard let shipScene = SCNScene(named: "ship.scn"),
//                    let shipNode = shipScene.rootNode.childNode(withName: "ship", recursively: false)
//                    else { return }
//                
//                
//                shipNode.position = SCNVector3(x,y,z)
//                sceneView.scene.rootNode.addChildNode(shipNode)
                
                
                
                self.node = node
            
                let scene = SCNScene(named: "SceneKit_Scene.scn")!
                
                // Set the scene to the view
                self.sceneView.scene = scene
                
                // Create a session configuration
                let configuration = ARWorldTrackingConfiguration()
                
                // Run the view's session
                self.sceneView.session.run(configuration)
                
//                self.sceneView.allowsCameraControl = true
            } else {
                print("err")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if first {
            changeResting()
            
            let touch = touches.first
            let touchPoint: CGPoint? = touch?.location(in: sceneView)
            let hitTestResult: SCNHitTestResult? = (sceneView.hitTest(touchPoint ?? CGPoint.zero, options: nil)).first
            let hitNode: SCNNode? = hitTestResult?.node
            
            if hitNode?.name == "box" {
                hitNode?.removeFromParentNode()
            }
            
            // click on platform to present box states
            if hitNode?.name == "plane" {
                checkResting()
            }
        }
    }
    
    func findNode() -> SCNNode? {
        return sceneView.scene.rootNode.childNode(withName: "container", recursively: false)
    }
    
    func changeResting() {
        for node in node!.childNodes {
            if node.name == "box" {
                node.physicsBody?.allowsResting = true
            }
        }
    }
    
    func checkResting() {
        for node in node!.childNodes {
            if node.name == "box" {
                print(node.physicsBody!.isResting, node.physicsBody!.velocity)
            }
        }
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        // 3
        plane.materials.first?.diffuse.contents = UIColor.blue
        
        // 4
        let planeNode = SCNNode(geometry: plane)
        
        // 5
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        
        // 6
        node.addChildNode(planeNode)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
