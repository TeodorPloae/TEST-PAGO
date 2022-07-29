//
//  AppCoordinator.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 29.07.2022.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<CoordinateResultType<Void>> {
        
        let navigationController = UINavigationController(rootViewController: ContactsViewController())
        
        let contactsCoordinator = ContactsCoordinator(rootNavigationController: navigationController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
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
        
    }
}

