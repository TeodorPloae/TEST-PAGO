//
//  ContactDetailsViewController.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 30.07.2022.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class ContactDetailsViewController: UIViewController {
    
    private var viewModel: ContactDetailsViewModel
    
    private var disposeBag = DisposeBag()
    
    private lazy var backButton: UIBarButtonItem = {
        makeBackButton()
    }()
    
    private lazy var button: UIButton = {
        makeButton()
    }()
    
    init(viewModel: ContactDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBaseLayout()
    }
    
    deinit {
        print("deinit called on \(NSStringFromClass(type(of: self)))")
    }
}

//MARK: Factory Methods
extension ContactDetailsViewController {
    private func makeButton() -> UIButton {
        let button = UIButton()
        button.setTitle("saveContact", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.didTapSaveButtonPublisher.onNext(())
            })
            .disposed(by: self.disposeBag)
        return button
    }
    
    private func makeBackButton() -> UIBarButtonItem {
        let newBackButton = UIBarButtonItem(image: .init(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backAction))
        return newBackButton
    }
    
    @objc func backAction() {
        viewModel.backActionPublisher.onNext(())
    }
}

//MARK: UI Setup
extension ContactDetailsViewController {
    private func setupBaseLayout() {
        view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = backButton
        
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

