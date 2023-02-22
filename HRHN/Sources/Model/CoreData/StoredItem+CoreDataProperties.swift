//
//  StoredItem+CoreDataProperties.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2023/02/20.
//
//

import Foundation
import CoreData

extension StoredItemMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredItemMO> {
        return NSFetchRequest<StoredItemMO>(entityName: "StoredItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var content: String?

}

extension StoredItemMO : Identifiable {

}
