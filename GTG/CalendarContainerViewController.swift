//
//  ViewController.swift
//  calendar-screen
//
//  Created by Shvetan Raj Katta on 10/14/23.
//

import UIKit
import CoreData

class CalendarContainerViewController: UIViewController {
    
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var dropDownButton: UIButton!

    var dateSelectionCallback: ((Date?) -> Void)?
    var toggle: ((Bool?) -> Void)?
    var dropDown: ((String?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createCalendar()
    }
    
    func createCalendar(){
        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.delegate = self
        calendarView.layer.cornerRadius = 10
        calendarView.tintColor = UIColor.systemTeal

//        calendarView.setVisibleDateComponents(calendarView.visibleDateComponents, animated: true)
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            calendarView.heightAnchor.constraint(equalToConstant: 400),
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
    }
    
}

extension CalendarContainerViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
//    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
//        let font = UIFont.systemFont(ofSize: 10)
//        let configuration = UIImage.SymbolConfiguration(font: font)
//
//        // Check condition on if they went to the gym
//        if true {
//            let blueImage = UIImage(systemName: "circlebadge.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal)
//            var redImage = UIImage(systemName: "circlebadge.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal).withTintColor(.systemRed, renderingMode: .alwaysOriginal)
//            let condition = true
//            if !condition{
//                return .image(blueImage)
//            }
//            else{
//                return .image(redImage)
//            }
//        } else {
//            // If the condition is not met, return nil to show no image
//            return nil
//        }
//    }
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        if let date = Calendar.current.date(from: dateComponents) {
            let dateString = dateFormatter.string(from: date)

            // Fetch workout data for the current date
            let fetchedData = CalendarCoreDataManager.shared.fetchWorkoutData(for: dateString)
            
            let font = UIFont.systemFont(ofSize: 10)
            let configuration = UIImage.SymbolConfiguration(font: font)
            let blueImage = UIImage(systemName: "circlebadge.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal)
            var redImage = UIImage(systemName: "circlebadge.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal).withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            var purpleImage = UIImage(systemName: "circlebadge.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal).withTintColor(.systemPurple, renderingMode: .alwaysOriginal)
            var grayImage = UIImage(systemName: "circlebadge.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal).withTintColor(.systemGray, renderingMode: .alwaysOriginal)

            if let data = fetchedData.first {
                if data.didWorkout {
                    // User went to the gym
                    let workoutType = data.workoutType

                    // Change cell color based on workout type
                    if workoutType == "Legs" {
                        return .image(redImage)
                    } else if workoutType == "Push" {
                        return .image(blueImage)
                    } else if workoutType == "Pull" {
                        return .image(purpleImage)
                    } else {
                        // Handle other workout types or set a default color
                        return .image(grayImage)
                    }
                } else {
                    // User did not workout
                    return nil
                }
            }
        }

        // Default decoration (no image)
        return nil
        }
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if let selectedDate = dateComponents {
            let date = Calendar.current.date(from: selectedDate)
            dateSelectionCallback?(date)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormatter.string(from: date!)
            let fetchedData = CalendarCoreDataManager.shared.fetchWorkoutData(for: dateString)
            if fetchedData.isEmpty{
                toggle?(false)
                dropDown?("No Workout")
            }
            for data in fetchedData {
                let fetchedWorkoutType = data.workoutType
                let fetchedDidWorkout = data.didWorkout
                toggle?(fetchedDidWorkout)
                dropDown?(fetchedWorkoutType)
            }
        } else {
            dateSelectionCallback?(nil)
            toggle?(false)
        }
    }
}

