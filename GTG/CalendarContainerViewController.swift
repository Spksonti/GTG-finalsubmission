//
//  ViewController.swift
//  calendar-screen
//
//  Created by Shvetan Raj Katta on 10/14/23.
//

import UIKit

class CalendarContainerViewController: UIViewController {
    
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var dropDownButton: UIButton!

    var dateSelectionCallback: ((Date?) -> Void)?

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
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        let font = UIFont.systemFont(ofSize: 10)
        let configuration = UIImage.SymbolConfiguration(font: font)
        
        // Check condition on if they went to the gym
        if true {
            let blueImage = UIImage(systemName: "circlebadge.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal)
            var redImage = UIImage(systemName: "circlebadge.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal).withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            let condition = true
            if !condition{
                return .image(blueImage)
            }
            else{
                return .image(redImage)
            }
        } else {
            // If the condition is not met, return nil to show no image
            return nil
        }
    }
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if let selectedDate = dateComponents {
            let date = Calendar.current.date(from: selectedDate)
            dateSelectionCallback?(date)
        } else {
            dateSelectionCallback?(nil)
        }
    }
}

