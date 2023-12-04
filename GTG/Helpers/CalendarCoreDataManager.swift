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
}
