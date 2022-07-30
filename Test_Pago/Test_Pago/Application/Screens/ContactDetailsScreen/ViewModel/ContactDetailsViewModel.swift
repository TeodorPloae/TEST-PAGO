//
//  ContactDetailsViewModel.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 30.07.2022.
//

import Foundation
import RxSwift
import RxCocoa

class ContactDetailsViewModel {
    let didTapSaveButtonPublisher = PublishSubject<Void>()
    let backActionPublisher = PublishSubject<Void>()
    
    deinit {
        print("deinit called on \(NSStringFromClass(type(of: self)))")
    }
}
