//
//  BaseCoordinator.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 29.07.2022.
//

import RxSwift

enum CoordinateResultType<T> {
    case executeAndReleaseTheCoordinator(T)
    case executeOnly(T)
}

class BaseCoordinator<ResultType>: NSObject {

    public typealias CoordinationResult = ResultType

    public let disposeBag = DisposeBag()
    
    private let identifier = UUID()
    
    private var childCoordinators = [UUID: Any]()

    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func release<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    open func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .map({ [weak self] result -> T in
            switch result {
                case .executeAndReleaseTheCoordinator(let object):
                    self?.release(coordinator: coordinator)
                    return object
                case .executeOnly(let object):
                    return object
            }
        })
    }

    open func start() -> Observable<CoordinateResultType<ResultType>> {
        fatalError("start() method must be implemented")
    }
    
    deinit {
        print("deinit called on \(NSStringFromClass(type(of: self)))")
    }
}
