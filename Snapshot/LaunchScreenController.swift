//
//  LaunchScreenController.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/24/21.
//

import Foundation
import UIKit

class LaunchScreenController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        image.image = UIImage(named: "SnapshotIcon")
        image.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        image.center = view.center
    }
}
