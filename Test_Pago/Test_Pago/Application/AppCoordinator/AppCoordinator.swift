//
//  AppCoordinator.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 29.07.2022.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    var rootNavigationController: UINavigationController
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    override func start() -> Observable<CoordinateResultType<Void>> {
        
        let launchScreenCoordinator = LaunchScreenCoordinator(rootNavigationController: rootNavigationController)
        
        coordinate(to: launchScreenCoordinator)
            .subscribe(onNext: { [weak self] coordinationResult in
                switch coordinationResult {
                case .dismiss:
                    self?.rootNavigationController.popViewController(animated: true)
                    self?.goToContacts()
                }
            })
            .disposed(by: disposeBag)
        
        return .never()
    }
    
    private func goToContacts() {
        let contactsCoordinator = ContactsCoordinator(rootNavigationController: rootNavigationController)
        
        coordinate(to: contactsCoordinator)
            .subscribe(onNext: { [weak self] coordinationResult in
                switch coordinationResult {
                case .goToCreateContact:
                    self?.goToContactDetails(flow: .create, contact: nil)
                case .goToUpdateContact(let contact):
                    self?.goToContactDetails(flow: .update, contact: contact)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func goToContactDetails(flow: Flow, contact: Contact?) {
        let contactDetailsCoordinator = ContactDetailsCoordinator(rootNavigationController: rootNavigationController, flow: flow, contact: contact)
        
        coordinate(to: contactDetailsCoordinator)
            .subscribe(onNext: { [weak self] coordinationResult in
                switch coordinationResult {
                case .dismiss:
                    self?.rootNavigationController.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

