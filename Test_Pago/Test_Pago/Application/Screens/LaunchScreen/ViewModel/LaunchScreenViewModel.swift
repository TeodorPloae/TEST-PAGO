//
//  LaunchScreenViewModel.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 30.07.2022.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class LaunchScreenViewModel {
    let didFinishLoadingData = PublishSubject<Void>()
    let showErrorAlert = PublishSubject<Message>()
    
    typealias Message = String
    
    private let contactsRepository = ContactsRepository()
    
    private let coreDataLoader = CoreDataLoader.shared
    
    init() {
        coreDataLoader.checkCoreDataEmpty { [weak self] result in
            switch result {
            case true:
                self?.loadContactsAndSaveToCoreData()
            case false:
                DispatchQueue.main.async {
                    self?.didFinishLoadingData.onNext(())
                }
            }
        }
    }
    
    private func loadContactsAndSaveToCoreData() {
        contactsRepository.getContacts() { [weak self] result in
            switch result {
            case .success(let contacts):
                let filteredContacts = contacts.filter {
                    $0.status == .active
                }
                self?.coreDataLoader.saveContactsToCoreData(contacts: filteredContacts) { [weak self] in
                    self?.didFinishLoadingData.onNext(())
                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.showErrorAlert.onNext(error.localizedDescription)
            }
        }
    }
    
    deinit {
        print("deinit called on \(NSStringFromClass(type(of: self)))")
    }
}
