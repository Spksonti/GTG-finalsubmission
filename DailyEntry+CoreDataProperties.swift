//
//  DailyEntry+CoreDataProperties.swift
//  GTG
//
//  Created by Shvetan Raj Katta on 12/4/23.
//
//

import Foundation
import CoreData


extension DailyEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyEntry> {
        return NSFetchRequest<DailyEntry>(entityName: "DailyEntry")
    }

    @NSManaged public var date: String?
    @NSManaged public var didWorkout: Bool
    @NSManaged public var typeOfWorkout: String?

}

extension DailyEntry : Identifiable {

}
