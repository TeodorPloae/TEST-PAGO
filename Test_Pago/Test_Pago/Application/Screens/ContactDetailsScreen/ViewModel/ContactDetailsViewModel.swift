//
//  ContactDetailsViewModel.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 30.07.2022.
//

import Foundation
import RxSwift
import RxCocoa

enum Flow {
    case update
    case create
}

class ContactDetailsViewModel {
    let backActionPublisher = PublishSubject<Void>()
    
    let coreDataLoader = ContactsDataLoader.shared
    
    let flow: Flow
    let contact: Contact?
    
    init(flow: Flow, contact: Contact?) {
        self.flow = flow
        self.contact = contact
    }
    
    func handleMainButtonAction(contactDetails: ContactDetails) {
        switch flow {
        case .update:
            coreDataLoader.updateContact(
                contact: contact!,
                contactDetails: contactDetails
            ) { [weak self] in
                self?.backActionPublisher.onNext(())
            }
        case .create:
            coreDataLoader.insertContactToCoreData(
                contactDetails: contactDetails
            ) { [weak self] in
                self?.backActionPublisher.onNext(())
            }
        }
    }
    
    deinit {
        print("deinit called on \(NSStringFromClass(type(of: self)))")
    }
}
