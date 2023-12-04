//
//  ViewController.swift
//  GTG
//
//  Created by Nikhil Meka on 9/26/23.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    var videoPlayer: AVPlayer?
    
    var videoPlayerLayer: AVPlayerLayer?
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        //Set up video in background
        setUpVideo()
        addGTGLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpVideo()
    {
        
        //Get the path to resource in media
        let bundlePath = Bundle.main.path(forResource: "loginbg", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        //Create URL
        let url = URL(fileURLWithPath: bundlePath!)
        
        //Create video player item
        let item = AVPlayerItem(url: url)
        
        //Create the player
        videoPlayer = AVPlayer(playerItem: item)
        
        //mute the video
        videoPlayer!.isMuted = true
        
        //Create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        //Adjust size and frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width * 1.5, y: 0,
                                         width: self.view.frame.size.width * 4, height: self.view.frame.size.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        //Display and play video
        videoPlayer?.playImmediately(atRate: 1)
    }

    func setUpElements()
    {
        //Style elements
        Utilities.styleFilledButton(createAccountButton)
        Utilities.styleHollowButtonWhite(loginButton)
    }
    
    func addGTGLabel() {
        let label = UILabel(frame: CGRect(x: 0, y: 50, width: view.frame.size.width, height: 100))
        label.text = "GTG"
        label.font = UIFont(name: "Impact", size: 80) // Using a different font
        label.textColor = UIColor.orange
        label.textAlignment = .center
        label.shadowColor = UIColor.darkGray // Adding a shadow
        label.shadowOffset = CGSize(width: 2, height: 2) // Adjusting shadow offset
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Adding a semi-transparent background

        // Round corners and border
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.layer.borderWidth = 3
        label.layer.borderColor = UIColor.white.cgColor

        view.addSubview(label)
    }

}


