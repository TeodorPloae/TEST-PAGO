//
//  Contact+CoreDataProperties.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 30.07.2022.
//
//

import Foundation
import CoreData
import UIKit


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var contactId: Int64
    @NSManaged public var firstName: String?
    @NSManaged public var email: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?

}

extension Contact : Identifiable {

}
