//
//  ViewController.swift
//  calendar-screen
//
//  Created by Shvetan Raj Katta on 10/14/23.
//

import UIKit

class FitnessConceptsViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentView = UIView()

        // Assuming you have set up the UIScrollView in your storyboard and connected it to the IBOutlet
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 5000)
        
        // Add content to the scroll view
        // Add your UI elements to the contentView
        scrollView.addSubview(contentView)
    }
}
