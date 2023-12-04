//
//  QuestionnaireViewController.swift
//  GTG
//
//  Created by Shriman Sonti on 10/10/23.
//

import UIKit



// dictionary with all the times available to go to the gym for each day
var freeTimes: [String: [String]] = [:]

// create goal which will ultimately be filled when continue button clicked
// created out of class to be global
var goal = Goal(fitnessGoal: "Feel healthier", gainLossVal: 0, currWeight: 0.0, freeTimes: freeTimes)


class QuestionnaireViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let timeList = ["6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM", "7:00 PM", "8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM", "12:00 AM"]
    
    let daysOfWeekList = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return daysOfWeekList.count
        }
        return timeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if component == 0
        {
            return daysOfWeekList[row]
        }
        else
        {
            return timeList[row]
        }
    }
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBAction func saveClicked(_ sender: Any) {
        let firstValue = timePicker.selectedRow(inComponent: 0)
        let secondValue = timePicker.selectedRow(inComponent: 1)
        let thirdValue = timePicker.selectedRow(inComponent: 2)

        if secondValue >= thirdValue {
            // times not valid
            errorLabel.text = "Please choose valid start and end times"
            // Change the background color to green
            timePicker.backgroundColor = UIColor.systemRed
            
            // Delay for a short period (e.g., 0.5 seconds)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Reset the background color to its original color
                self.timePicker.backgroundColor = UIColor.clear
            }
            return
        }
        // valid times: add to dictionary in form startTime - endTime
        let timeRange = timeList[secondValue] + "-" + timeList[thirdValue]
        // Change the background color to green
        timePicker.backgroundColor = UIColor.green
        
        // Delay for a short period (e.g., 0.5 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Reset the background color to its original color
            self.timePicker.backgroundColor = UIColor.clear
        }
        
        goal.addFreeTimes(dayOfWeek: daysOfWeekList[firstValue], timeToAdd: timeRange)
    }
    // questionnaire variables (buttons + dow controll)
    @IBOutlet weak var weightGoalsButton: UIButton!
    @IBOutlet weak var gainLoseText: UILabel!
    @IBOutlet weak var weightChange: UILabel!
    @IBOutlet weak var weightField: UITextField!
    
    @IBOutlet weak var liftingGoalField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    // button actions
    @IBAction func upClicked(_ sender: Any) {
        self.weightChange.text = String(Int(self.weightChange.text!)! + 1)
    }
    @IBAction func downClicked(_ sender: Any) {
        var val = Int(self.weightChange.text!)!
        if val < 1 {
            val = 1
        }
        self.weightChange.text = String(val - 1)
    }
    
    var currentWeight: Double = 0.0
    var liftingGoal: String = ""
    @IBAction func continueClicked(_ sender: Any) {
        currentWeight = Double(String(weightField.text!)) ?? 0.0
        goal.changeCurrWeight(currWeight: currentWeight)
        liftingGoal = liftingGoalField.text!
        goal.changeGoal(fitnessGoal: liftingGoal)
        goal.changeGainLossVal(gainLossVal: Int(self.weightChange.text!)!)
        performSegue(withIdentifier: "toSummaryView", sender: self)
    }
    
    
    
    // storing whether user is "Bulking" or "Cutting"
    var selectedWeightGoal: String! = nil
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Bulk (Gain Weight)", image: nil, handler: { (_) in
                self.selectedWeightGoal = "Bulking"
                goal.changeLoseOrGain(loseOrGain: "Gain")
                
                self.weightGoalsButton.setTitle(self.selectedWeightGoal, for: .normal)
                self.gainLoseText.text = "Enter the number of lbs you want to gain:"
                
                
                
            }),
            UIAction(title: "Cut (Lose Weight)", image: nil, handler: { (_) in
                self.selectedWeightGoal = "Cutting"
                goal.changeLoseOrGain(loseOrGain: "Lose")
                
                self.weightGoalsButton.setTitle(self.selectedWeightGoal, for: .normal)
                self.gainLoseText.text = "Enter the number of lbs you want to lose:"
                
            })
        ]
    }

    var weightGoalsMenu: UIMenu {
        return UIMenu(title: "Weight Goals", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Utilities.styleFilledButton(weightGoalsButton)
        Utilities.styleFilledButton(downButton)
        Utilities.styleFilledButton(upButton)
        Utilities.styleTextField(weightField)
        Utilities.styleTextField(liftingGoalField)
        Utilities.styleFilledButton(continueButton)
        Utilities.styleFilledButton(saveButton)
        
        weightGoalsButton.showsMenuAsPrimaryAction = true
        weightGoalsButton.menu = weightGoalsMenu
        weightChange.text = String(0)
        self.timePicker.delegate = self
        self.timePicker.dataSource = self
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
