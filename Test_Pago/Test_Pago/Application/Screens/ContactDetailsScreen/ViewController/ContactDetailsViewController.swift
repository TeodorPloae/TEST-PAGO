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
    
    private var contentView = UIView()
    
    private lazy var backButton: UIBarButtonItem = {
        makeBackButton()
    }()
    
    private lazy var contentStackView: UIStackView = {
        makeContentStackView()
    }()
    
    private lazy var headerView: UIView = {
        makeHeaderView()
    }()
    
    private lazy var cardsScrollView: UIScrollView = {
        makeCardsScrollView()
    }()
    
    private lazy var mainButton: UIButton = {
        makeMainButton()
    }()
    
    private var lastNameTextField = UITextField()
    
    private var firstNameTextField = UITextField()
    
    private var phoneTextField = UITextField()
    
    private var emailTextField = UITextField()
    
    private var isFirstLoad: Bool = true
    
    init(viewModel: ContactDetailsViewModel) {
        self.viewModel = viewModel
    
        super.init(nibName: nil, bundle: nil)
        
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = backButton
        registerForKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard isFirstLoad == true else { return }
        isFirstLoad = false
        
        setupBaseLayout()
        setupLayoutForContact()
    }
    
    deinit {
        print("deinit called on \(NSStringFromClass(type(of: self)))")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

//MARK: TextFIeld Delegate
extension ContactDetailsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: "XXXX XXX XXX", phone: newString)
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

//MARK: Helper Methods
extension ContactDetailsViewController {
    ///code from https://stackoverflow.com/questions/32364055/formatting-phone-number-in-swift
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    private func textFieldsAreValid() -> Bool{
        let lastNameFieldIsValid = lastNameTextField.text != ""
        let firstNameFieldIsValid = firstNameTextField.text != ""
        
        return lastNameFieldIsValid && firstNameFieldIsValid
    }
    
    private func showTextFieldsNotValidAlert() {
        let message = LocalizedString(key: "contact_details_text_fields_not_valid")
        let alert = UIAlertController(title: LocalizedString(key: "warning"),
                                      message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
}

//MARK: Keyboard Interaction
extension ContactDetailsViewController {
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
            let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
            let keyboardSize = keyboardInfo.cgRectValue.size
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            cardsScrollView.contentInset = contentInsets
            cardsScrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        cardsScrollView.contentInset = .zero
        cardsScrollView.scrollIndicatorInsets = .zero
    }
}

//MARK: UI Setup
extension ContactDetailsViewController {
    private func setupBaseLayout() {
        view.backgroundColor = .white
        
        view.addSubview(contentView)
        let contentViewFrame = view.bounds.inset(by: view.safeAreaInsets)
        contentView.frame = contentViewFrame
        
        contentView.addSubview(contentStackView)
        contentView.addSubview(mainButton)
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupLayoutForContact() {
        guard let contact = viewModel.contact else { return }
        
        firstNameTextField.text = contact.firstName
        lastNameTextField.text = contact.lastName
        phoneTextField.text = contact.phoneNumber
        emailTextField.text = contact.email
    }
}

//MARK: Factory Methods
extension ContactDetailsViewController {
    private func makeBackButton() -> UIBarButtonItem {
        let newBackButton = UIBarButtonItem(image: .init(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backAction))
        return newBackButton
    }
    
    @objc func backAction() {
        viewModel.backActionPublisher.onNext(())
    }
    
    private func makeContentStackView() -> UIStackView {
        let vStack = UIStackView()
        vStack.axis = .vertical
        
        vStack.addArrangedSubview(headerView)
        vStack.addArrangedSubview(cardsScrollView)
        
        return vStack
    }
    
    private func makeHeaderView() -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = LocalizedString(key: "contact_details_screen_title_add_contact")
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(24)
        }
            
        return headerView
    }
    
    private func makeCardsScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .extra_light_blue
        
        let vStackContainer = UIView()
        vStackContainer.backgroundColor = .extra_light_blue
        scrollView.addSubview(vStackContainer)
        vStackContainer.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 24
        vStackContainer.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        let lastNameInputCard = makeInputCard(textField: lastNameTextField,
                                              titleText: LocalizedString(key: "contact_details_screen_last_name_card_title"))
        let firstNameInputCard = makeInputCard(textField: firstNameTextField,
                                               titleText: LocalizedString(key: "contact_details_screen_first_name_card_title"))
        let phoneInputCard = makeInputCard(textField: phoneTextField,
                                           titleText: LocalizedString(key: "contact_details_screen_phone_card_title"))
        let emailInputCard = makeInputCard(textField: emailTextField,
                                           titleText: LocalizedString(key: "contact_details_screen_email_card_title"))
        
        vStack.addArrangedSubview(lastNameInputCard)
        vStack.addArrangedSubview(firstNameInputCard)
        vStack.addArrangedSubview(phoneInputCard)
        vStack.addArrangedSubview(emailInputCard)
        
        return scrollView
    }
    
    private func makeInputCard(textField: UITextField, titleText: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        
        let label = UILabel()
        label.text = titleText.uppercased()
        label.textColor = .light_blue
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
        }
        
        view.addSubview(textField)
        textField.borderStyle = .none
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).inset(-16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        let underlineView = UIView()
        view.addSubview(underlineView)
        underlineView.backgroundColor = .extra_light_blue
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalTo(textField)
            make.leading.equalTo(textField)
            make.top.equalTo(textField.snp.bottom)
            make.bottom.equalToSuperview().inset(16)
        }
        
        return view
    }
    
    private func makeMainButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .lime_green
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        
        switch viewModel.flow {
        case .update:
            button.setTitle(LocalizedString(key: "contact_details_main_button_update"), for: .normal)
        case .create:
            button.setTitle(LocalizedString(key: "contact_details_main_button_save"), for: .normal)
        }
        
        button.addTarget(self,
                         action: #selector(handleMainButtonAction),
                         for: .touchUpInside)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        return button
    }
    
    @objc func handleMainButtonAction() {
        if textFieldsAreValid() {
            let contactDetails = ContactDetails(firstName: firstNameTextField.text!,
                                                lastName: lastNameTextField.text!,
                                                phoneNumber: phoneTextField.text,
                                                email: emailTextField.text)
            viewModel.handleMainButtonAction(contactDetails: contactDetails)
        } else {
            showTextFieldsNotValidAlert()
        }
    }
}



