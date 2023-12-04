//
//  HomeNextWorkoutViewController.swift
//  GTG
//
//  Created by Akif Abidi on 11/5/23.
//

import UIKit

class HomeNextWorkoutViewController: UIViewController {

    @IBOutlet weak var day3Label: UILabel!
    @IBOutlet weak var day2Label: UILabel!
    @IBOutlet weak var day1Label: UILabel!

    // Day buttons
    @IBOutlet weak var day1Button1: UIButton!
    @IBOutlet weak var day1Button2: UIButton!
    
    @IBOutlet weak var day2Button1: UIButton!
    @IBOutlet weak var day2Button2: UIButton!
    
    @IBOutlet weak var day3Button1: UIButton!
    @IBOutlet weak var day3Button2: UIButton!
    
    @IBOutlet weak var headingLabel: UILabel!
    
    private var dayLabelList: [UILabel]!
    private var timeButtonLists: [[UIButton]]!
    private var flattenedFreeTime: [(String, [String])] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headingLabel.text = "🏃 Next time to GTG "

        setUpUIList()
    }
    
    // load data here to ensure freeTime data is up to date (LoginViewController queries from Firebase and saves to goal, needs to happen after viewDidLoad)
    override func viewDidAppear(_ animated: Bool) {
        populateFreeTimeOptions()
    }
    
    private func setUpUIList() {
        // array of days with their corresponding options
        self.dayLabelList = [
            day1Label,
            day2Label,
            day3Label
        ]
        
        self.timeButtonLists = [
            [day1Button1, day1Button2],
            [day2Button1, day2Button2],
            [day3Button1, day3Button2]
        ]
        
        hideButtons()
    }
    
    
    private func populateFreeTimeOptions() {
        
        // Important: being a dictionary, the keys are unordered
        // so we need to make it into a flattened list and then order it. the logic for the days shoudl be a lot more simple
        
        flattenedFreeTime = flattenFreeTime()
        print(flattenedFreeTime)
        
        // get day of the week
        let todayDayOfWeek: String = getDayOfWeek()
        
        // to help with iteration. We iterate till daycounter >=3 after we find today, and if the day has a non empty freetimes list
        var todayDayKeyFound = false
        var dayCounter = 0
    
        // iterate through  userFreeTimes array and displays data of the current day + the following days
      
        for (dayString, todayFreeTimesArr) in flattenedFreeTime {
            
            // toggle that the day we want to start has been found. We will iterate for the next two days in the
            if dayString == todayDayOfWeek {
                todayDayKeyFound = true
            }
            
            // Once curernt today is found, iterate through today and the following two days
            if todayDayKeyFound && !todayFreeTimesArr.isEmpty && (dayCounter < 3) {
                
                // get corresponding UILabel and UIButtons
                let currDayLabel: UILabel = dayLabelList[dayCounter]
                let currDayTimeButtonArr: [UIButton] = timeButtonLists[dayCounter]
                
                // get substring of full day: ex - "Monday" becomes "Mon"
                let abbreviatedDayString = String(dayString.prefix(3))
                
                // Inserting data into UI buttons and labels
                updateFreeTimesOnUI(todayString: abbreviatedDayString, todayfreeTimeArray: todayFreeTimesArr, currDayLabel: currDayLabel, timeRangeButtonsArr: currDayTimeButtonArr)
                
                
                // increment counter
                dayCounter += 1
            }
        }

    }
        
    private func flattenFreeTime() -> [(String, [String])] {
        // get dictionary version of free time
        let userFreeTimes = goal.getFreeTimes()
        
        // Flatten the dictionary into an array of (day, time interval) pairs
        var newArrFlat: [(String, [String])] = userFreeTimes.compactMap { (day, intervals) in
            return (day, intervals)
        }
        

        let dayOrder: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

        // Sort the flattenedData based on the custom order
        newArrFlat.sort { (pair1, pair2) in
            if let index1 = dayOrder.firstIndex(of: pair1.0),
               let index2 = dayOrder.firstIndex(of: pair2.0) {
                return index1 < index2
            } else {
                return false
            }
        }
        
        return newArrFlat
    }
    
    
    private func updateFreeTimesOnUI(todayString todayDayOfWeek: String, todayfreeTimeArray todayFreeTimesArr: [String], currDayLabel dayLabel: UILabel, timeRangeButtonsArr freeTimesButtonArr: [UIButton]) {
        
        // set day label
        dayLabel.isHidden = false
        dayLabel.text = todayDayOfWeek
        
        // all buttons are hidden by default, see setUpUIList()
        if (todayFreeTimesArr.count >= 2) {
            // make both buttons visible and update title
            freeTimesButtonArr[0].isHidden = false
            freeTimesButtonArr[0].setTitle(todayFreeTimesArr[0], for: .normal)
            
            freeTimesButtonArr[1].isHidden = false
            freeTimesButtonArr[1].setTitle(todayFreeTimesArr[1], for: .normal)
            
        } else if (todayFreeTimesArr.count == 1) { // else just show first free-time range
            freeTimesButtonArr[0].isHidden = false
            freeTimesButtonArr[0].setTitle(todayFreeTimesArr[0], for: .normal) // show first button
        }
        
    }
    
    // return string of today's irl day of the week
    private func getDayOfWeek() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
   
    
    private func hideButtons() {
        // Begin with all labels and buttons hidden, they will be unhidden when data is put in them
        self.dayLabelList.forEach { label in
            label.isHidden = true
        }
        
        self.timeButtonLists.forEach { button in
            button[0].isHidden = true
            button[1].isHidden = true
        }
    }
    
    
    private func showChosenNextTime(buttonTime timeString: String, buttonDay dayString: String) {
        // clear the UI view
        hideButtons()
        
        // Change heading label of view
        self.headingLabel.text = "See you at the gym at"
        
        // create a Label
        let label = UILabel()

        // Set the text and other properties of the label
        label.text = "\(dayString), \(timeString)"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)

        // Add the label as a subview to its parent view (self.view)
        self.view.addSubview(label)

        // Disable autoresizing mask constraints
        label.translatesAutoresizingMaskIntoConstraints = false

        // Create Auto Layout constraints to center the label within its parent view
        NSLayoutConstraint.activate([
           label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
           label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])

        
        
    }
    
    // Next Time to GTG Button functionality------
    
    // DAY 1, BUTTON 1
    @IBAction func pressDay1Button1(_ sender: UIButton) {
        // give it the time of the selected button
        showChosenNextTime(buttonTime: sender.currentTitle!, buttonDay: day1Label.text!)
    }
    
    // DAY 1, BUTTON 1
    @IBAction func pressDay1Button2(_ sender: UIButton) {
        // give it the time of the selected button
        showChosenNextTime(buttonTime: sender.currentTitle!, buttonDay: day1Label.text!)

    }
    
    // DAY 2, BUTTON 1
    @IBAction func pressDay2Button1(_ sender: UIButton) {
        showChosenNextTime(buttonTime: sender.currentTitle!, buttonDay: day2Label.text!)
    }
    
    // DAY 2, BUTTON 2
    @IBAction func pressDay2Button2(_ sender: UIButton) {
        showChosenNextTime(buttonTime: sender.currentTitle!, buttonDay: day2Label.text!)
    }
    
    // DAY 3 BUTTON 1
    @IBAction func pressDay3Button1(_ sender: UIButton) {
        showChosenNextTime(buttonTime: sender.currentTitle!, buttonDay: day3Label.text!)
    }
    
    // DAY 3 BUTTON 2
    @IBAction func pressDay3Button2(_ sender: UIButton) {
        showChosenNextTime(buttonTime: sender.currentTitle!, buttonDay: day3Label.text!)
    }
}
