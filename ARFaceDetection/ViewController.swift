//
//  ViewController.swift
//  ARFaceDetection
//
//  Created by Aayush Shah on 7/1/21.
//

import UIKit
import ARKit
import SceneKit


class ViewController: UIViewController, ARSCNViewDelegate {
    
    struct settingBool {
        static var Record:Bool = false /// Setting Default as False
    }
    
    struct CSV {
        static var file_name = ""
        static var csvHead:String = "time, .eyeBlinkLeft,.eyeLookDownLeft,.eyeLookInLeft,.eyeLookOutLeft,.eyeLookUpLeft,.eyeSquintLeft,.eyeWideLeft,.eyeBlinkRight,.eyeLookDownRight,.eyeLookInRight,.eyeLookOutRight,.eyeLookUpRight,.eyeSquintRight,.eyeWideRight,.jawForward,.jawLeft,.jawRight,.jawOpen,.mouthClose,.mouthFunnel,.mouthPucker,.mouthLeft,.mouthRight,.mouthSmileLeft,.mouthSmileRight,.mouthFrownLeft,.mouthFrownRight,.mouthDimpleLeft,.mouthDimpleRight,.mouthStretchRight,.mouthRollLower,.mouthRollUpper,.mouthShrugLower,.mouthShrugUpper,.mouthPressLeft,.mouthPressRight,.mouthLowerDownLeft,.mouthLowerDownRight,.mouthUpperUpLeft,.mouthUpperUpRight,.browDownLeft,.browDownRight,.browInnerUp,.browOuterUpLeft,.browOuterUpRight,.cheekPuff,.cheekSquintLeft,.cheekSquintRight,.noseSneerLeft,.noseSneerRight,.tongueOut\n"
    }
    
    @IBOutlet weak var faceView: ARSCNView!
    
    @IBOutlet weak var recordbutton: UIButton!
    
    @IBAction func recordbutton(_ sender: UIButton) {
        //sender is the button that was pressed
        settingBool.Record = !settingBool.Record
        if settingBool.Record {
            recordbutton.setTitle("Stop!", for: .normal)
            
            CSV.file_name = "\(Date())" + ".csv"
        }
        else {
            recordbutton.setTitle("Record!", for: .normal)
            do {
                var path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(CSV.file_name)
                try CSV.csvHead.write(to: path!, atomically: true, encoding: .utf8)
                let exportSheet = UIActivityViewController(activityItems: [path as Any], applicationActivities: nil)
                self.present(exportSheet, animated: true, completion: nil)
                print("Exported")
            } catch {
                print("Error")
            }
            CSV.file_name = ""
            CSV.csvHead = ".eyeBlinkLeft,.eyeLookDownLeft,.eyeLookInLeft,.eyeLookOutLeft,.eyeLookUpLeft,.eyeSquintLeft,.eyeWideLeft,.eyeBlinkRight,.eyeLookDownRight,.eyeLookInRight,.eyeLookOutRight,.eyeLookUpRight,.eyeSquintRight,.eyeWideRight,.jawForward,.jawLeft,.jawRight,.jawOpen,.mouthClose,.mouthFunnel,.mouthPucker,.mouthLeft,.mouthRight,.mouthSmileLeft,.mouthSmileRight,.mouthFrownLeft,.mouthFrownRight,.mouthDimpleLeft,.mouthDimpleRight,.mouthStretchRight,.mouthRollLower,.mouthRollUpper,.mouthShrugLower,.mouthShrugUpper,.mouthPressLeft,.mouthPressRight,.mouthLowerDownLeft,.mouthLowerDownRight,.mouthUpperUpLeft,.mouthUpperUpRight,.browDownLeft,.browDownRight,.browInnerUp,.browOuterUpLeft,.browOuterUpRight,.cheekPuff,.cheekSquintLeft,.cheekSquintRight,.noseSneerLeft,.noseSneerRight,.tongueOut\n"
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordbutton.backgroundColor = UIColor.black
        recordbutton.layer.cornerRadius = 25.0
        recordbutton.tintColor = UIColor.white
        faceView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARFaceTrackingConfiguration()
        faceView.session.run(configuration)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        faceView.session.pause()
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
           /*
            You can implement this method to provide a new SCNNode object (or instance of an SCNNode subclass)
            containing any attachments you plan to use as a visual representation of the anchor. Note that ARKit
            controls the node's visibility and its transform property, so you may find it useful to add child nodes or adjust
            the node's pivot property to maintain any changes to position or orientation that you make.
            */

            let faceMesh = ARSCNFaceGeometry(device: faceView.device!)
             /*
             ARSCNFaceGeometry is a subclass of SCNGeometry that wraps the mesh data provided by the
             ARFaceGeometry class. You can use ARSCNFaceGeometry to quickly and easily visualize face topology and
             facial expressions provided by ARKit in a SceneKit view.
            */
            
            let node = SCNNode(geometry: faceMesh)
            // SCNNode is a structural element of a scene graph, representing a position and transform in a 3D coordinate space.
            
            node.geometry?.firstMaterial?.fillMode = .lines
            // make it lines
            
            return node
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            /*
            Tells the delegate that a SceneKit node's properties have been updated to match the current state of its corresponding anchor.
            renderer : The ARSCNView object rendering the scene
            node : The updated SceneKit node
            anchor : The AR anchor corresponding to the node
             */
            
            if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
                    faceGeometry.update(from: faceAnchor.geometry)
                // everytime the mesh detects an update
                    
                    readMyFace(anchor: faceAnchor)
                    // run readMyFace function
                
                    // Update the text on the main thread
            }
        }

        func readMyFace(anchor: ARFaceAnchor) {
            if (settingBool.Record) {
                var calendar = Calendar.current

                if let timeZone = TimeZone(identifier: "EST") {
                   calendar.timeZone = timeZone
                }
                
                let d = Date()
                let df = DateFormatter()
                df.dateFormat = "H:m:ss:SSSS"

                
                CSV.csvHead.append("\(df.string(from: d)), \(anchor.blendShapes[.eyeBlinkLeft]!), \(anchor.blendShapes[.eyeLookDownLeft]!), \(anchor.blendShapes[.eyeLookInLeft]!), \(anchor.blendShapes[.eyeLookOutLeft]!), \(anchor.blendShapes[.eyeLookUpLeft]!), \(anchor.blendShapes[.eyeSquintLeft]!), \(anchor.blendShapes[.eyeWideLeft]!), \(anchor.blendShapes[.eyeBlinkRight]!), \(anchor.blendShapes[.eyeLookDownRight]!), \(anchor.blendShapes[.eyeLookInRight]!), \(anchor.blendShapes[.eyeLookOutRight]!), \(anchor.blendShapes[.eyeLookUpRight]!), \(anchor.blendShapes[.eyeSquintRight]!), \(anchor.blendShapes[.eyeWideRight]!), \(anchor.blendShapes[.jawForward]!), \(anchor.blendShapes[.jawLeft]!), \(anchor.blendShapes[.jawRight]!), \(anchor.blendShapes[.jawOpen]!), \(anchor.blendShapes[.mouthClose]!), \(anchor.blendShapes[.mouthFunnel]!), \(anchor.blendShapes[.mouthPucker]!), \(anchor.blendShapes[.mouthLeft]!),                \(anchor.blendShapes[.mouthRight]!), \(anchor.blendShapes[.mouthSmileLeft]!), \(anchor.blendShapes[.mouthSmileRight]!), \(anchor.blendShapes[.mouthFrownLeft]!),      \(anchor.blendShapes[.mouthFrownRight]!), \(anchor.blendShapes[.mouthDimpleLeft]!), \(anchor.blendShapes[.mouthDimpleRight]!), \(anchor.blendShapes[.mouthStretchRight]!), \(anchor.blendShapes[.mouthRollLower]!), \(anchor.blendShapes[.mouthRollUpper]!), \(anchor.blendShapes[.mouthShrugLower]!), \(anchor.blendShapes[.mouthShrugUpper]!), \(anchor.blendShapes[.mouthPressLeft]!), \(anchor.blendShapes[.mouthPressRight]!), \(anchor.blendShapes[.mouthLowerDownLeft]!), \(anchor.blendShapes[.mouthLowerDownRight]!), \(anchor.blendShapes[.mouthUpperUpLeft]!), \(anchor.blendShapes[.mouthUpperUpRight]!), \(anchor.blendShapes[.browDownLeft]!), \(anchor.blendShapes[.browDownRight]!), \(anchor.blendShapes[.browInnerUp]!), \(anchor.blendShapes[.browOuterUpLeft]!), \(anchor.blendShapes[.browOuterUpRight]!), \(anchor.blendShapes[.cheekPuff]!), \(anchor.blendShapes[.cheekSquintLeft]!), \(anchor.blendShapes[.cheekSquintRight]!), \(anchor.blendShapes[.noseSneerLeft]!), \(anchor.blendShapes[.noseSneerRight]!), \(anchor.blendShapes[.tongueOut]!)\n")
            }
        }

}

extension TimeInterval {
    var hourMinuteSecondMS: String {
        String(format:"%d:%02d:%02d.%03d", hour, minute, second, millisecond)
    }
    var minuteSecondMS: String {
        String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}


