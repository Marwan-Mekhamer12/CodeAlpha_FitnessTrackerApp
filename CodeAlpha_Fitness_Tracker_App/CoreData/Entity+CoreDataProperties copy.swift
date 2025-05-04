//
//  Entity+CoreDataProperties.swift
//  
//
//  Created by Marwan Mekhamer on 04/05/2025.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var check: Bool

}
