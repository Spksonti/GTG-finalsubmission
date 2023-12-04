//
//  HomeViewController.swift
//  GTG
//
//  Created by Shriman Sonti on 10/10/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var calendarHolderView: UIView!
    
    @IBOutlet weak var displayWeight: UILabel!
    @IBOutlet weak var displayGoalWeight: UILabel!
    @IBOutlet weak var displayBulkOrCut: UILabel!
    
    
    enum Segues {
        static let homeGoalsSegue = "toHomeGoals"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createCalendar()
        
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: when clicked, it must go to the goals summary screen
        if segue.identifier == Segues.homeGoalsSegue {
            let destVC = segue.destination as! HomeGoalsViewController
            
        }

    }

}

