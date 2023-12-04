//
//  CalendarCoreDataManager.swift
//  GTG
//
//  Created by Shvetan Raj Katta on 12/3/23.
//

import CoreData
import UIKit

class CalendarCoreDataManager {
    static let shared = CalendarCoreDataManager()

    func saveWorkoutToCoreData(date: String, workoutType: String, workoutCompleted: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entry = DailyEntry(context: context)
        entry.date = date
        entry.typeOfWorkout = workoutType
        entry.didWorkout = workoutCompleted

        do {
            try context.save()
        } catch {
            print("Error saving workout data: \(error)")
        }
    }
    
    func fetchWorkoutData(for date: String) -> [(date: String, workoutType: String, didWorkout: Bool)] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DailyEntry> = DailyEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date)

        do {
            let entries = try context.fetch(fetchRequest)
            let workoutData = entries.map { entry in
                return (date: entry.date ?? "", workoutType: entry.typeOfWorkout ?? "", didWorkout: entry.didWorkout)
            }
            return workoutData
        } catch {
            print("Error fetching workout data: \(error)")
            return []
        }
    }
    
    func saveDarkModeState(isEnabled: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            // Fetch existing DarkMode entity or create a new one if it doesn't exist
            let fetchRequest: NSFetchRequest<DarkMode> = DarkMode.fetchRequest()
            let darkModeEntities = try context.fetch(fetchRequest)
            let darkModeEntity = darkModeEntities.first ?? DarkMode(context: context)

            // Update the DarkMode entity with the new state
            darkModeEntity.darkMode = isEnabled

            // Save the changes
            try context.save()
        } catch {
            print("Error saving DarkMode state: \(error)")
        }
    }
    
    func fetchDarkModeState() -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DarkMode> = DarkMode.fetchRequest()

        do {
            let darkModeEntities = try context.fetch(fetchRequest)
            if let darkModeEntity = darkModeEntities.first {
                return darkModeEntity.darkMode
            } else {
                // Default value when there's no DarkMode entity
                return false
            }
        } catch {
            print("Error fetching DarkMode state: \(error)")
            // Default value in case of an error
            return false
        }
    }
}
