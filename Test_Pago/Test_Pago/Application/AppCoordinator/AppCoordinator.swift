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
        
        let contactsCoordinator = ContactsCoordinator(rootNavigationController: rootNavigationController)
        
        coordinate(to: contactsCoordinator)
            .subscribe(onNext: { [weak self] coordinationResult in
                switch coordinationResult {
                case .goToContactDetails:
                    self?.goToContactDetails()
                }
            })
            .disposed(by: disposeBag)
        
        return .never()
    }
    
    private func goToContactDetails() {
        let contactDetailsCoordinator = ContactDetailsCoordinator(rootNavigationController: rootNavigationController)
        
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

