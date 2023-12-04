//
//  HomeCalendarViewController.swift
//  GTG
//
//  Created by Akif Abidi on 11/7/23.
//

import UIKit

class HomeCalendarViewController: UIViewController {
    
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var dropDownButton: UIButton!

    var dateSelectionCallback: ((Date?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createCalendar()
    }
    
    func createCalendar(){
        
        /*
         
         Check out this research to see if it works:
         Constraining to the parent view
         https://stackoverflow.com/questions/52968328/how-to-make-swift-uiview-child-element-shrink-automaticaly-when-parent-uiviews
         
         changing the calendar size
         https://stackoverflow.com/questions/75844540/uicalendarview-overflowing
         https://developer.apple.com/documentation/uikit/uiview/1622526-setcontentcompressionresistancep/
         
         Using a Scroll view for everything but the bottom bar?
          - consider makign a nav bar
         https://www.youtube.com/watch?v=xBtQsacfDhQ&t=109slmaooo
         
         Try changing color below in TODO in extension class instead of having images in them
         */
        let calendarView = UICalendarView()
    
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.delegate = self
        calendarView.layer.cornerRadius = 10
        calendarView.tintColor = UIColor.systemOrange
        
        // Set date range
        calendarView.availableDateRange = DateInterval.init(start: Date.distantPast, end: Date.now)

        calendarView.setVisibleDateComponents(calendarView.visibleDateComponents, animated: true)
        
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(calendarView)

        calendarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

//
//        view.addSubview(calendarView)
//
//        NSLayoutConstraint.activate([
//            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            calendarView.heightAnchor.constraint(equalToConstant: 290),
//            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10)
//        ])
    }
    
}

extension HomeCalendarViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {

        let font = UIFont.systemFont(ofSize: 7, weight: .light, width: .compressed)
        let configuration = UIImage.SymbolConfiguration(font: font)
        
        
        // TODO: TRY CHANGING THE COLOR HERE INSTEAD OF THE RED AND BLUE DOTS: EASIER TO SEE
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
