//
//  GoalsSummaryVC.swift
//  GTG
//
//  Created by Nikhil Meka on 10/31/23.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore

class GoalsSummaryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var freeTimes = goal.getFreeTimes()
    var flattenedData: [(String, String)] = []
    var removedValues: [(String, String)] = []
    @IBAction func toHomeScreen(_ sender: Any) {
        for removedValue in removedValues {
            let myArray = freeTimes[removedValue.0]
            if let index = myArray!.firstIndex(where: { $0 == removedValue.1 }) {
                freeTimes[removedValue.0]!.remove(at: index)
            } else {
                print("Element not found in the array")
            }
        }
        goal.updateFreeTimes(newTimes: freeTimes)
        performSegue(withIdentifier: "summaryToHome", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removedValues.append(flattenedData[indexPath.row])
            flattenedData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flattenedData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeTimeCell", for: indexPath) as! FreeTimeTableViewCell

        let (day, timeInterval) = flattenedData[indexPath.row]

        cell.dayOfWeekLabel.text = day
        cell.timeIntervalLabel.text = timeInterval

        return cell
    }
    
    @IBOutlet weak var goalsDisplayLabel: UILabel!
    @IBOutlet weak var freeTimesTable: UITableView!
    
    @IBOutlet weak var continueButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(continueButton)
        // weight goal, fitness goal, gym habit goal
        let weight_goal = goal.getLoseOrGain()
        let weight_change = goal.getWeightChangeGoal()
        goalsDisplayLabel.text = """
                    Weight change: \(weight_goal) \(weight_change) lbs
                    Current Weight: \(goal.getCurrWeight())
                    """
        freeTimesTable.delegate = self
        freeTimesTable.dataSource = self
        
        // push data to firebase
        if let userUID = userAccount?.uid {
            let userRef = Firestore.firestore().collection("Users").document(userUID)
            goal.updateFirebaseGoal(userRef: userRef)
        } else {
            // Handle the case where userAccount?.uid is nil
            print("Error: User UID is nil")
        }
        
        // Flatten the dictionary into an array of (day, time interval) pairs
        flattenedData = freeTimes.flatMap { (day, intervals) in
            return intervals.map { (day, $0) }
        }
        let dayOrder: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

        // Sort the flattenedData based on the custom order
        flattenedData.sort { (pair1, pair2) in
            if let index1 = dayOrder.firstIndex(of: pair1.0),
               let index2 = dayOrder.firstIndex(of: pair2.0) {
                return index1 < index2
            } else {
                return false
            }
        }
        freeTimesTable.reloadData()
        // Do any additional setup after loading the view.
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
