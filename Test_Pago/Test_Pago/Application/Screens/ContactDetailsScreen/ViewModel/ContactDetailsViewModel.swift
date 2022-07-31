//
//  ContactDetailsViewModel.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 30.07.2022.
//

import Foundation
import RxSwift
import RxCocoa

enum Flow {
    case edit
    case create
}

class ContactDetailsViewModel {
    let didTapSaveButtonPublisher = PublishSubject<Void>()
    let backActionPublisher = PublishSubject<Void>()
    
    let flow: Flow = .create
    
    deinit {
        print("deinit called on \(NSStringFromClass(type(of: self)))")
    }
}
