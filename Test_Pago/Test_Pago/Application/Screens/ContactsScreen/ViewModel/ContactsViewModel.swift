//
//  ContactsViewModel.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 29.07.2022.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class ContactsViewModel {
    let goToContactDetailsPublisher = PublishSubject<Void>()
    let reloadTableViewData = PublishSubject<Void>()
    
    private let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
    
    var coreDataContacts = [Contact]() {
        didSet {
            reloadTableViewData.onNext(())
        }
    }
    
    init() {
        fetchContacts()
    }
    
    private func fetchContacts() {
        let contactsFetch: NSFetchRequest<Contact> = Contact.fetchRequest()
        do {
            let results = try managedContext.fetch(contactsFetch)
            coreDataContacts = results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}
