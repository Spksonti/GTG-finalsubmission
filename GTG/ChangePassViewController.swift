//
//  ChangePassViewController.swift
//  SettingsNProfile
//
//  Created by Shvetan Raj Katta on 11/1/23.
//

import UIKit
import Firebase

class ChangePassViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) 
    {
        
        let cleanedEmail = emailAddressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isValidEmail(cleanedEmail) == false
        {
            errorLabel.text = "Enter a valid email"
            errorLabel.alpha = 1
        }
        else
        {
            let auth = Auth.auth()
            
            auth.sendPasswordReset(withEmail: emailAddressTextField.text!) {
                (error) in
                if error != nil
                {
                    self.errorLabel.text = "Not a valid email, try again!"
                    self.errorLabel.alpha = 1
                }
            }
            
            errorLabel.text = "Please check your email for a reset password email"
            errorLabel.textColor = UIColor.blue
            errorLabel.alpha = 1
        }
    }
    
}
