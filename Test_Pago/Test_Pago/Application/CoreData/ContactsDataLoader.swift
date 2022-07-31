//
//  ContactsDataLoader.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 30.07.2022.
//

import Foundation
import CoreData

class ContactsDataLoader {
    
    static let shared: ContactsDataLoader = ContactsDataLoader()
    
    let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
    
    private var contacts = [Contact]()
    
    func fetchContacts(completion: @escaping ([Contact]) -> Void) {
        let contactsFetch: NSFetchRequest<Contact> = Contact.fetchRequest()
        do {
            let results = try managedContext.fetch(contactsFetch)
            contacts = results
            completion(contacts)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
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
    
    func insertContactToCoreData(contactDetails: ContactDetails,
                                 completion: @escaping () -> Void) {
        
        let newContact = Contact(context: managedContext)
        newContact.setValue(contactDetails.firstName, forKey: #keyPath(Contact.firstName))
        newContact.setValue(contactDetails.lastName, forKey: #keyPath(Contact.lastName))
        newContact.setValue(contactDetails.phoneNumber, forKey: #keyPath(Contact.phoneNumber))
        newContact.setValue(contactDetails.email, forKey: #keyPath(Contact.email))
        
        self.contacts.insert(newContact, at: 0)
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        
        completion()
    }
    
    func updateContact(contact: Contact,
                       contactDetails: ContactDetails,
                       completion: @escaping () -> Void) {
        
        let contactToUpdate = contacts.first { $0 == contact }
        contactToUpdate?.setValue(contactDetails.firstName, forKey: #keyPath(Contact.firstName))
        contactToUpdate?.setValue(contactDetails.lastName, forKey: #keyPath(Contact.lastName))
        contactToUpdate?.setValue(contactDetails.phoneNumber, forKey: #keyPath(Contact.phoneNumber))
        contactToUpdate?.setValue(contactDetails.email, forKey: #keyPath(Contact.email))
        
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
