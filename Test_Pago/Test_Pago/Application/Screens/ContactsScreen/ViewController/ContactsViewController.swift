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

    private var contentView = UIView()
    
    private lazy var contentStackView: UIStackView = {
        makeContentStackView()
    }()
    
    private lazy var headerView: UIView = {
        makeHeaderView()
    }()
    
    private lazy var addContactButton: UIButton = {
        makeAddContactButton()
    }()
    
    private lazy var tableHeaderView: UIView = {
        makeTableHeaderView()
    }()
    
    private lazy var contactsTableView: UITableView = {
        makeContactsTableView()
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
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    private func setupUI() {
        setupBaseLayout()
    }
}

//MARK: TableView Delegates
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactTableViewCell.self)) as! ContactTableViewCell
        return cell
    }
    
    
}

//MARK: Factory Methods
extension ContactsViewController {
    
    private func makeContentStackView() -> UIStackView {
        let vStack = UIStackView()
        vStack.axis = .vertical
        
        vStack.addArrangedSubview(headerView)
        vStack.addArrangedSubview(tableHeaderView)
        vStack.addArrangedSubview(contactsTableView)
        
        return vStack
    }
    
    private func makeHeaderView() -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = LocalizedString(key: "contacts_screen_title")
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(addContactButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(24)
        }
        
        addContactButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(24)
        }
            
        return headerView
    }
    
    private func makeAddContactButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "add_contact_icon"), for: .normal)
        button.layer.borderColor = UIColor.extra_light_blue.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 7
        
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.goToContactDetailsPublisher.onNext(())
            })
            .disposed(by: self.disposeBag)
        return button
    }
    
    private func makeTableHeaderView() -> UIView {
        let tableHeaderView = UIView()
        tableHeaderView.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.text = LocalizedString(key: "contacts_screen_table_header_title").uppercased()
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = .light_blue
        
        tableHeaderView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(11)
            make.leading.equalToSuperview().inset(24)
        }
        
        return tableHeaderView
    }
    
    private func makeContactsTableView() -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .extra_light_blue
        
        tableView.register(ContactTableViewCell.self,
                           forCellReuseIdentifier: String(describing: ContactTableViewCell.self))
        
        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }
}

//MARK: UI Setup
extension ContactsViewController {
    private func setupBaseLayout() {
        view.backgroundColor = .extra_light_blue
        setupNavBarAppearance()
        view.addSubview(contentView)
        let contentViewFrame = view.bounds.inset(by: view.safeAreaInsets)
        contentView.frame = contentViewFrame
        
        contentView.addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
