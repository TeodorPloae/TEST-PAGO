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
        
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    override func start() -> Observable<CoordinateResultType<CoordinationResult>> {
        
        let viewModel = ContactDetailsViewModel()
        
        let viewController = ContactDetailsViewController(viewModel: viewModel)
        
        rootNavigationController.pushViewController(viewController, animated: true)
        
        let dismissObserver = viewModel.didTapSaveButtonPublisher
            .map({ CoordinateResultType.executeAndReleaseTheCoordinator(
                CoordinationResult.dismiss) })
        let backActionObserver = viewModel.backActionPublisher
            .map({ CoordinateResultType.executeAndReleaseTheCoordinator(
                CoordinationResult.dismiss) })
        
        return Observable.merge(dismissObserver, backActionObserver)
            .take(1)
    }
}
