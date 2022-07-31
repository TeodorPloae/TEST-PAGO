//
//  ContactsCoordinator.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 29.07.2022.
//

import UIKit
import RxSwift

enum ContactsCoordinatorResult {
    case goToCreateContact
    case goToUpdateContact(Contact)
}

class ContactsCoordinator: BaseCoordinator<ContactsCoordinatorResult> {
    
    let rootNavigationController: UINavigationController
        
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    override func start() -> Observable<CoordinateResultType<CoordinationResult>> {
        
        let viewModel = ContactsViewModel()
        
        let viewController = ContactsViewController(viewModel: viewModel)
        
        rootNavigationController.setViewControllers([viewController], animated: true)
        
        let goToCreateContactObserver = viewModel.goToCreateContactPublisher
            .map({ CoordinateResultType.executeOnly(
                CoordinationResult.goToCreateContact) })
        let goToUpdateContactObserver = viewModel.goToUpdateContact
            .map({contact in CoordinateResultType.executeOnly(
                CoordinationResult.goToUpdateContact(contact)) })
        
        return Observable.merge(goToCreateContactObserver, goToUpdateContactObserver)
    }
}
