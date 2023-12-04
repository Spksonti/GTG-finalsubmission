//
//  UpdateProfileViewController.swift
//  SettingsNProfile
//
//  Created by Shvetan Raj Katta on 10/30/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class UpdateProfileViewController: UIViewController {
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var changePassword: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateElements()
    }
    
    func updateElements()
    {
        //Hide error label
        errorLabel.alpha = 0
        
        //styling the elements
        Utilities.styleTextField(firstNameText)
        Utilities.styleTextField(lastNameText)
        Utilities.styleFilledButton(updateButton)
    }
    
    //Check to ensure fields are validated and correct
    func validateFields() -> String?
    {
        //Check fields are filled in
        if firstNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        return nil
    }
    
    @IBAction func updateAccountTapped(_ sender: Any)
    {
        //Validate fields
        let error = validateFields()
        
        if error != nil{
            //an error occurred, show error message
            errorLabel.text = error!
            errorLabel.alpha = 1
            
        }
        else
        {
            //Create cleaned versions of create account data
            let firstName = firstNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Update user stuff - TODO: Shriman
            if let userUID = userAccount?.uid {
                let userRef = Firestore.firestore().collection("Users").document(userUID)
                userRef.setData(["First Name" : firstName, "Last Name" : lastName], merge: true)
            }
        }
    }
    
}
