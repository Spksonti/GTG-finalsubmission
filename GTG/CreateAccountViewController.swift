//
//  CreateAccountViewController.swift
//  GTG
//
//  Created by Shriman Sonti on 10/10/23.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

var userAccount: User?


class CreateAccountViewController: UIViewController {

    
    @IBOutlet weak var firstNameText: UITextField!
    
    @IBOutlet weak var lastNameText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        

        // Do any additional setup after loading the view.
    }
    
    func setUpElements()
    {
        //Hide error label
        errorLabel.alpha = 0
        
        //styling the elements
        Utilities.styleTextField(firstNameText)
        Utilities.styleTextField(lastNameText)
        Utilities.styleTextField(emailText)
        Utilities.styleTextField(passwordText)
        Utilities.styleFilledButton(createAccountButton)
    }
    
    //Check to ensure fields are validated and correct
    func validateFields() -> String?
    {
        //Check fields are filled in
        if firstNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        //Check if email is valid
        let cleanedEmail = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isValidEmail(cleanedEmail) == false
        {
            return "Ensure email is in correct format."
        }
        
        //Check if password valid
        let cleanedPassword = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isValidPassword(cleanedPassword) == false
        {
            //TODO: fix this so that it displays correctly
            return "Password needs: 8 characters, special character, and number."
        }
        
        return nil
    }
    
    @IBAction func createAccountTapped(_ sender: Any) 
    {
        //Validate fields
        let error = validateFields()
        
        if error != nil{
            //an error occurred, show error message
            errorLabel.numberOfLines = 0
            errorLabel.text = error!
            errorLabel.alpha = 1
            
            errorLabel.adjustsFontSizeToFitWidth = true
            errorLabel.minimumScaleFactor = 0.5
        }
        else
        {
            //Create cleaned versions of create account data
            let firstName = firstNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create user
            Auth.auth().createUser(withEmail: email, password: password){ (result, err) in
                
                //Check for error
                if err != nil
                {
                    //An error is found
                    self.errorLabel.text = "Error creating user, user may exist already"
                    self.errorLabel.alpha = 1
                }
                else
                {
                    //User created successfully, store first and last name
                    let db = Firestore.firestore()
                    
                
                    userAccount = User(fn: firstName, ln: lastName, uid: result!.user.uid)
                    
                    db.collection("Users").document(result!.user.uid).setData(["First Name" : firstName, "Last Name" : lastName, "uid" : result!.user.uid]) { (error) in
                        
                        if error != nil{
                            self.errorLabel.text = "Error saving user data"
                            self.errorLabel.alpha = 1
                        }
                    }
                    
                    //Transition to questionnaire screen
                    //Can connect after questionnaire screen is created
                    self.transitionToQuestionnaireScreen()
                    
                }
                
            }
        }
    }
    
    
    //Function to transition the screen to the homescreen once
    //all values are set correctly
    func transitionToQuestionnaireScreen()
    {
        //Used to transition into the homescreen
        let questionnaireVC = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.questionnaireViewController) as? QuestionnaireViewController
        
        view.window?.rootViewController = questionnaireVC
        view.window?.makeKeyAndVisible()
    }
    

}
