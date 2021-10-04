//
//  ViewController.swift
//  smile-reader
//
//  Created by Alejandro Ulloa on 4/10/21.
//

import UIKit
import ARKit
import SnapKit

class ViewController: UIViewController {
  
  let sceneView = ARSCNView()
  
  let smileLabel = UILabel()
  
  let imageView = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard ARFaceTrackingConfiguration.isSupported else {
      fatalError("Device does not support face tracking")
    }
    AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
      if (granted) {
        // We're going to implement this function in a minute
        DispatchQueue.main.async {
          self.setupSmileTracker()
        }
      } else {
        fatalError("User did not grant camera permission!")
      }
    }
  }
  
  func setupSmileTracker() {
    buildARScenView()
    buildSmileLabel()
    buildImageView()
  }
  
  func buildARScenView() {
    let configuration = ARFaceTrackingConfiguration()
    sceneView.session.run(configuration)
    sceneView.delegate = self
    view.addSubview(sceneView)
    
    sceneView.snp.makeConstraints {
      $0.center.equalTo(view)
      $0.edges.equalTo(view)
    }
  }
  
  func buildSmileLabel() {
    smileLabel.text = "😐"
    smileLabel.font = UIFont.systemFont(ofSize: 150)
    view.addSubview(smileLabel)
    smileLabel.snp.makeConstraints {
      $0.leading.equalTo(view).offset(15)
      $0.bottom.equalTo(view).offset(-15)
    }
  }
  
  func buildImageView() {
    view.addSubview(imageView)
    imageView.contentMode = .scaleAspectFit
    imageView.snp.makeConstraints {
      $0.bottom.trailing.equalTo(view).offset(-15)
      $0.width.equalTo(200)
      $0.height.equalTo(300)
    }
  }
  
  func handleSmile(smileValue: CGFloat) {
    switch smileValue {
      case _ where smileValue > 0.5:
        smileLabel.text = "😁"
        let image = sceneView.snapshot()
        imageView.image = image
      case _ where smileValue > 0.2:
        smileLabel.text = "🙂"
      default:
        smileLabel.text = "😐"
    }
  }
}


extension ViewController: ARSCNViewDelegate {
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    // Cast anchor as ARFaceAnchor
    guard let faceAnchor = anchor as? ARFaceAnchor else { return }
    
    // Pull left/right smile coefficents from blendShapes
    let leftMouthSmileValue = faceAnchor.blendShapes[.mouthSmileLeft] as! CGFloat
    let rightMouthSmileValue = faceAnchor.blendShapes[.mouthSmileRight] as! CGFloat
    
    DispatchQueue.main.async {
      // Update label for new smile value
      self.handleSmile(smileValue: (leftMouthSmileValue + rightMouthSmileValue)/2.0)
    }
  }
  
}
