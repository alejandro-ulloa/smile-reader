//
//  ViewController.swift
//  smile-reader
//
//  Created by Alejandro Ulloa on 4/10/21.
//

import UIKit
import ARKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    guard ARFaceTrackingConfiguration.isSupported else {
      fatalError("Device does not support face tracking")
    }
  }


}

