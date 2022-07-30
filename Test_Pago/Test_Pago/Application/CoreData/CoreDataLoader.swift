//
//  CoreDataLoader.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 30.07.2022.
//

import Foundation
import CoreData

class CoreDataLoader {
    
    static let shared: CoreDataLoader = CoreDataLoader()
    
    let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
    
    private var contacts = [Contact]()
    
    func saveContactsToCoreData(contacts: [ContactNetworkModel],
                                        completion: @escaping () -> Void) {
        contacts.forEach {
            let newContact = Contact(context: managedContext)
            newContact.setValue($0.id, forKey: #keyPath(Contact.contactId))
            newContact.setValue($0.email, forKey: #keyPath(Contact.email))
            newContact.setValue($0.name, forKey: #keyPath(Contact.firstName))

            self.contacts.insert(newContact, at: 0)
        }

        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        
        completion()
    }
    
    func checkCoreDataEmpty(completion: @escaping (Bool) -> Void) {
        
        let contactsFetch: NSFetchRequest<Contact> = Contact.fetchRequest()
        do {
            let results = try managedContext.fetch(contactsFetch)
            
            if results.isEmpty {
                completion(true)
            } else {
                completion(false)
            }
            
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}
