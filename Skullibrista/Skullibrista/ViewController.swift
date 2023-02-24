//
//  ViewController.swift
//  Skullibrista
//
//  Created by Vinicius Loss on 23/02/23.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var street: UIImageView!
    @IBOutlet weak var player: UIImageView!
    @IBOutlet weak var viGameOver: UIView!
    @IBOutlet weak var lbTimePlayed: UILabel!
    @IBOutlet weak var lbInstructions: UILabel!
    
    var isMoving = false
    lazy  var motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viGameOver.isHidden = true
        
        street.frame.size.width = view.frame.size.width * 2
        street.frame.size.height = view.frame.size.height * 2
        street.center = view.center
        
        player.center = view.center
        player.animationImages = []
        for i in 0...7 {
            let image = UIImage(named: "player\(i)")!
            player.animationImages?.append(image)
        }
        player.animationDuration = 0.5
        player.startAnimating()

        Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { (timer) in
            self.start()
        }
    }
    
    func start(){
        lbInstructions.isHidden = true
        viGameOver.isHidden = true
        isMoving = false
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                if error == nil {
                    if let data = data {
                        print("X: ", data.gravity.x, "Y: ", data.gravity.y, "Z: ", data.gravity.z)
                        let angle = atan2(data.gravity.x, data.gravity.y) - .pi
                        self.player.transform = CGAffineTransform(rotationAngle: angle)
                    }
                }
            }
        }
        
        
    }

    @IBAction func playAgain(_ sender: UIButton) {
    }
    
}

