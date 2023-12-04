//
//  ViewController.swift
//  calendar-screen
//
//  Created by Shvetan Raj Katta on 10/14/23.
//

import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    
    // adjust based on user inputs
    let workouts = ["Workout", "Push", "Pull", "Legs", "Rest"]
    
    let workoutChange = {(action: UIAction) in
        //updateWorkout(action.title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setWorkoutMenu()
    }
    func setWorkoutMenu(){
        dropDownButton.menu = UIMenu(children: [
            UIAction(title: "No Workout", handler: workoutChange),
            UIAction(title: "Push", handler: workoutChange),
            UIAction(title: "Pull", handler: workoutChange),
            UIAction(title: "Legs", handler: workoutChange),
            UIAction(title: "Rest", handler: workoutChange)
        ])
        dropDownButton.changesSelectionAsPrimaryAction = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showCalendarContainer" {
                if let calendarContainerVC = segue.destination as? CalendarContainerViewController {
                    calendarContainerVC.dateSelectionCallback = { [weak self] selectedDate in
                        if let selectedDate = selectedDate {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MMM dd, yyyy"
                            let dateString = dateFormatter.string(from: selectedDate)
                            self?.dateLabel.text = dateString
                        } else {
                            self?.dateLabel.text = "No date selected"
                        }
                    }
                }
            }
        }
}
