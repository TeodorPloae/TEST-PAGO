//
//  ContactsCoordinator.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 29.07.2022.
//

import UIKit
import RxSwift

enum ContactsCoordinatorResult {
    case goToContactDetails
}

class ContactsCoordinator: BaseCoordinator<ContactsCoordinatorResult> {
    
    let rootNavigationController: UINavigationController
        
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    override func start() -> Observable<CoordinateResultType<CoordinationResult>> {
        
        let viewModel = ContactsViewModel()
        
        let viewController = ContactsViewController(viewModel: viewModel)
        
        rootNavigationController.pushViewController(viewController, animated: true)
        
        let goToContactDetailsObserver = viewModel.goToContactDetailsPublisher
            .map({ CoordinateResultType.executeOnly(
                CoordinationResult.goToContactDetails) })
        
        return Observable.merge(goToContactDetailsObserver)
    }
}
