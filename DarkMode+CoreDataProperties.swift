//
//  DarkMode+CoreDataProperties.swift
//  GTG
//
//  Created by Shvetan Raj Katta on 12/4/23.
//
//

import Foundation
import CoreData


extension DarkMode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DarkMode> {
        return NSFetchRequest<DarkMode>(entityName: "DarkMode")
    }

    @NSManaged public var darkMode: Bool

}

extension DarkMode : Identifiable {

}
