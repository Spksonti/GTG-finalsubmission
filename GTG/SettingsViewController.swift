//
//  ViewController.swift
//  SettingsNProfile
//
//  Created by Shvetan Raj Katta on 10/30/23.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    @IBOutlet weak var updateProfile: UIButton!
    @IBOutlet weak var updateQuestionnaire: UIButton!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let fetchedData = CalendarCoreDataManager.shared.fetchDarkModeState()
        darkModeSwitch.isOn = fetchedData
        updateElements()
    }
    
    func updateElements()
    {
        //styling the elements
        Utilities.styleFilledButton(updateProfile)
        Utilities.styleFilledButton(updateQuestionnaire)
    }
    
    @IBAction func onClickSwitch(_ sender: Any){
        CalendarCoreDataManager.shared.saveDarkModeState(isEnabled: darkModeSwitch.isOn)
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let appDelegate = windowScene.windows.first
                if let sender = sender as? UISwitch {
                    if sender.isOn {
                        appDelegate?.overrideUserInterfaceStyle = .dark
                    } else {
                        appDelegate?.overrideUserInterfaceStyle = .light
                    }
                }
            }
        }
    }
    
    @IBAction func signOutButton(_ sender: Any)
    {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "SignOutSegue", sender: self)
        } catch {
            print("Sign out error")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignOutSegue" {
            if let destinationVC = segue.destination as? ViewController {
                destinationVC.modalPresentationStyle = .fullScreen
            }
        }
    }
    
}

