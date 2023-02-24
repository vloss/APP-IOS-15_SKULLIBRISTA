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
    lazy var motionManager = CMMotionManager()
    var gameTimer: Timer!
    var startDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viGameOver.isHidden = true
        
        street.frame.size.width = view.frame.size.width * 2
        street.frame.size.height = street.frame.size.width * 2
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
        startDate = Date()
        
        self.player.transform = CGAffineTransform(rotationAngle: 0)
        self.street.transform = CGAffineTransform(rotationAngle: 0)
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                if error == nil {
                    if let data = data {
                        print("X: ", data.gravity.x, "Y: ", data.gravity.y, "Z: ", data.gravity.z)
                        let angle = atan2(data.gravity.x, data.gravity.y) - .pi
                        self.player.transform = CGAffineTransform(rotationAngle: angle)
                        
                        if !self.isMoving {
                            self.checkGameOver()
                        }
                    }
                }
            }
        }
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { (timer) in
            self.rotateWorld()
        })
    }
    
    func rotateWorld(){
        let randomAngle = Double(arc4random_uniform(120))/100 - 0.6
        
        isMoving = true
        
        UIView.animate(withDuration: 0.75, animations: {
            self.street.transform = CGAffineTransform(rotationAngle: CGFloat(randomAngle))
        }) {(success) in
            self.isMoving = false
        }
    }
    
    func checkGameOver(){

        let worldAngle = atan2(street.transform.a, street.transform.b)
        let playerAngle = atan2(player.transform.a, player.transform.b)
        let difference = abs(worldAngle - playerAngle)
        
        if difference > 0.25 {
            gameTimer.invalidate()
            viGameOver.isHidden = false
            motionManager.stopDeviceMotionUpdates()
            
            let secondsPlayed = round(Date().timeIntervalSince(startDate))
            lbTimePlayed.text = "Você jogou durante \(secondsPlayed) segundos"
        }
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        start()
    }
}
