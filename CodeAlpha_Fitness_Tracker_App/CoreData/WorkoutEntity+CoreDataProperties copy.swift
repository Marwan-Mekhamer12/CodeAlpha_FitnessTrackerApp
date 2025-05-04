//
//  WorkoutEntity+CoreDataProperties.swift
//  
//
//  Created by Marwan Mekhamer on 04/05/2025.
//
//

import Foundation
import CoreData


extension WorkoutEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
        return NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
    }

    @NSManaged public var type: String?
    @NSManaged public var duration: Int16
    @NSManaged public var date: Date?
    @NSManaged public var calories: Double
    @NSManaged public var notes: String?
    @NSManaged public var check: Bool

}
