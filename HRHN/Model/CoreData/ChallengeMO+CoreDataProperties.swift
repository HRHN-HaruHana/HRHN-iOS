//
//  ChallengeMO+CoreDataProperties.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/23.
//
//

import Foundation
import CoreData


extension ChallengeMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChallengeMO> {
        return NSFetchRequest<ChallengeMO>(entityName: "Challenge")
    }

    @NSManaged public var date: Date
    @NSManaged public var content: String
    @NSManaged public var emoji: String
    @NSManaged public var id: UUID

}

extension ChallengeMO : Identifiable {

}
