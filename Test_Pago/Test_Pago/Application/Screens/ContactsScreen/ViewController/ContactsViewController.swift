//
//  ContactsViewController.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 29.07.2022.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class ContactsViewController: UIViewController {
    
    private var viewModel: ContactsViewModel
    
    private var disposeBag = DisposeBag()
    
    private lazy var button: UIButton = {
        makeButton()
    }()
    
    init(viewModel: ContactsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        setupBaseLayout()
    }
}

//MARK: Factory Methods
extension ContactsViewController {
    private func makeButton() -> UIButton {
        let button = UIButton()
        button.setTitle("goToContactDetails", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.goToContactDetailsPublisher.onNext(())
            })
            .disposed(by: self.disposeBag)
        return button
    }
}

//MARK: UI Setup
extension ContactsViewController {
    private func setupBaseLayout() {
        view.backgroundColor = .white
        
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
