//
//  LaunchScreenCoordinator.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 30.07.2022.
//

import UIKit
import RxSwift

enum LaunchScreenCoordinatorResult {
    case dismiss
}

class LaunchScreenCoordinator: BaseCoordinator<LaunchScreenCoordinatorResult> {
    
    let rootNavigationController: UINavigationController
        
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    override func start() -> Observable<CoordinateResultType<CoordinationResult>> {
        
        let viewModel = LaunchScreenViewModel()
        
        addSubscribers(viewModel: viewModel)
        
        let viewController = LaunchScreenViewController(viewModel: viewModel)
        
        rootNavigationController.pushViewController(viewController, animated: true)
        
        let dismissObserver = viewModel.didFinishLoadingData
            .map({ CoordinateResultType.executeAndReleaseTheCoordinator(
                CoordinationResult.dismiss) })
        
        return Observable.merge(dismissObserver)
            .take(1)
    }
    
    private func addSubscribers(viewModel: LaunchScreenViewModel) {
        viewModel.showErrorAlert
            .subscribe(onNext: { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            })
            .disposed(by: disposeBag)
    }
    
    private func showErrorAlert(message: String) {
        //TODO: add error alert
    }
}
