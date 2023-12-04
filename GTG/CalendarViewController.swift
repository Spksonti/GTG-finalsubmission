//
//  ViewController.swift
//  calendar-screen
//
//  Created by Shvetan Raj Katta on 10/14/23.
//

import UIKit
import CoreData

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    @IBAction func submitButton(_ sender: UIButton) {
        // Get the selected date from your UI
        let selectedDate = dateLabel.text
        let workoutType = dropDownButton.title(for: .normal) ?? "No Workout"
        let workoutCompleted = toggleSwitch.isOn

        CalendarCoreDataManager.shared.saveWorkoutToCoreData(date: selectedDate!, workoutType: workoutType, workoutCompleted: workoutCompleted)
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
                calendarContainerVC.dropDown = { [weak self] dropDown in
                    self!.dropDownButton.setTitle(dropDown!, for: .normal)
                }
                calendarContainerVC.toggle = { [weak self] toggle in
                    self!.toggleSwitch.isOn = toggle ?? false
                }
            }
        }
    }
}
