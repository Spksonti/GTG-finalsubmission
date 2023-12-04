//
//  Utilities.swift
//  GTG
//
//  Created by Shriman Sonti on 10/10/23.
//

import Foundation
import UIKit

class Utilities
{
    
    static func styleTextField(_ textfield:UITextField)
    {
        //Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2,
                                  width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 255/255, green: 160/255, blue: 0/255, alpha:1).cgColor
        
        //Remove border on text field
        textfield.borderStyle = .none
        
        //Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
    }
    
    static func styleFilledButton(_ button:UIButton)
    {
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 255/255, green: 160/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton)
    {
        //Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    static func styleHollowButtonWhite(_ button:UIButton)
    {
        //Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleSegmentedControl(_ segControl:UISegmentedControl)
    {
        //Hollow rounded corner style
        segControl.layer.borderWidth = 2
        segControl.backgroundColor = UIColor.init(red: 255/255, green: 160/255, blue: 0/255, alpha: 1)
        segControl.layer.cornerRadius = 25.0
        segControl.tintColor = UIColor.black
    }
    
    //Check to see if email is valid
    static func isValidEmail(_ email: String) -> Bool {
       let emailRegEx =
           "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let emailPred = NSPredicate(format:"SELF MATCHES %@",
           emailRegEx)
       return emailPred.evaluate(with: email)
    }
    
    //Checks to see if the password is valid
    static func isValidPassword(_ password: String) -> Bool {
        
        //checks to see lowercase letters and a special character and more than 8 letters
        let passwordRegex = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    
        return passwordTest.evaluate(with: password)
    }
    
    
}
