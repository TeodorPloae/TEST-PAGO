//
//  ContactDetailsCoordinator.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 30.07.2022.
//

import UIKit
import RxSwift

enum ContactDetailsCoordinatorResult {
    case dismiss
}

class ContactDetailsCoordinator: BaseCoordinator<ContactDetailsCoordinatorResult> {
    
    let rootNavigationController: UINavigationController
    let flow: Flow
    let contact: Contact?
        
    init(rootNavigationController: UINavigationController,
         flow: Flow,
         contact: Contact?
    ) {
        self.rootNavigationController = rootNavigationController
        self.flow = flow
        self.contact = contact
    }
    
    override func start() -> Observable<CoordinateResultType<CoordinationResult>> {
        
        let viewModel = ContactDetailsViewModel(flow: flow, contact: contact)
        
        let viewController = ContactDetailsViewController(viewModel: viewModel)
        
        rootNavigationController.pushViewController(viewController, animated: true)
        
        let dismissObserver = viewModel.backActionPublisher
            .map({ CoordinateResultType.executeAndReleaseTheCoordinator(
                CoordinationResult.dismiss) })
        
        return Observable.merge(dismissObserver)
            .take(1)
    }
}
