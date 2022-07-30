//
//  LaunchScreenViewController.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 30.07.2022.
//

import Foundation
import UIKit
import SnapKit

class LaunchScreenViewController: UIViewController {
    
    private var viewModel: LaunchScreenViewModel
    
    init(viewModel: LaunchScreenViewModel) {
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
        view.backgroundColor = .extra_light_blue
        
        let activityIndicator = UIActivityIndicatorView()
        
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        activityIndicator.startAnimating()
    }
    
    deinit {
        print("deinit called on \(NSStringFromClass(type(of: self)))")
    }
}
