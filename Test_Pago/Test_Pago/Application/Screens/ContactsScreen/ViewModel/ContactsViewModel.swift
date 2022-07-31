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
    let goToCreateContactPublisher = PublishSubject<Void>()
    let goToUpdateContact = PublishSubject<Contact>()
    let reloadTableViewData = PublishSubject<Void>()
    
    private let contactsDataLoader = ContactsDataLoader.shared
    
    var coreDataContacts = [Contact]() {
        didSet {
            reloadTableViewData.onNext(())
        }
    }
    
    func fetchContacts() {
        contactsDataLoader.fetchContacts { [weak self] contacts in
            self?.coreDataContacts = contacts
        }
    }
}
