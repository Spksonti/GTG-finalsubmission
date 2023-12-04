//
//  LogInViewController.swift
//  GTG
//
//  Created by Shriman Sonti on 10/10/23.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseCore
import FirebaseFirestore

//// created out of class to be global
//var goal = Goal(fitnessGoal: "placeholder", gymHabitGoal: "placeholder", gainLossVal: 0, currWeight: 0, freeTimes: freeTimes)

class LogInViewController: UIViewController {

    var userData: [String: Any?] = [:]
    var goalData: [String: Any?] = [:]
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements()
    {
        //Hide error label
        errorText.alpha = 0
        
        //Style elements
        Utilities.styleTextField(emailText)
        Utilities.styleTextField(passwordText)
        Utilities.styleFilledButton(loginButton)
    }
    
    
    func validateFields() -> String?
    {
        if emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please ensure all fields are filled out."
        }
        return nil
    }
    @IBAction func loginButtonTapped(_ sender: Any)
    {
        
        
        //Validate Text Fields
        let error = validateFields()
        
        
        if error != nil
        {
            errorText.text = error!
            errorText.alpha = 1
        }
        else
        {
            let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //Signing in the User
            Auth.auth().signIn(withEmail: email, password: password)
            { [self]
                (result, error) in
                
                if error != nil
                {
                    //Couldn't sign in
                    self.errorText.text = "Email/Password is wrong, try again!"
                    self.errorText.alpha = 1
                }
                else
                {
                    // get userAccount from firebase
                    let db = Firestore.firestore()
                    guard let userID = Auth.auth().currentUser?.uid else { return }
                    
                    let docRef = db.collection("Users").document(userID)
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            if let data = document.data() {
                                self.userData = [
                                    "First Name": data["First Name"]!,
                                    "Last Name": data["Last Name"]!,
                                    "uid": data["uid"]!
                                ]
                                // create user for this session
                                userAccount = User(fn: self.userData["First Name"] as! String, ln: self.userData["Last Name"] as! String, uid: self.userData["uid"] as! String)
                                
                                self.goalData = [
                                    "Goal": data["Goal"]!,
                                    "Current Weight": data["Current Weight"]!,
                                    "GainOrLoss Value": data["GainOrLoss Value"]!,
                                    "Free Time": data["Free Time"]!,
                                    "Last Updated": data["Last Updated"]!
                                ]
                                // create user for this session
                                goal = Goal(fitnessGoal: self.goalData["Goal"] as! String, gainLossVal: self.goalData["GainOrLoss Value"] as! Int, currWeight: self.goalData["Current Weight"] as! Double, freeTimes: self.goalData["Free Time"] as! [String : [String]], lastUpdated: self.goalData["Last Updated"] as! Timestamp)
                            }
                        } else {
                            print("Document does not exist or there was an error: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                    self.transitionToHomeScreen()
                }
            }
        }
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "ForgotPasswordSegue", sender: self)
    }
    
    
    
    
    //Transition to the home screen
    func transitionToHomeScreen()
    {
        //Used to transition into the homescreen
        let homeVC = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
    }
    
    

}
