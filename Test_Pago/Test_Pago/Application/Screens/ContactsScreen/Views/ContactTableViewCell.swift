//
//  ContactTableViewCell.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 30.07.2022.
//

import UIKit
import SnapKit
import Alamofire

class ContactTableViewCell: UITableViewCell {
    
    private lazy var photoImageView: UIImageView = {
        makePhotoImageView()
    }()
    
    private lazy var nameLabel: UILabel = {
        makeNameLabel()
    }()
    
    private lazy var arrowImageView: UIImageView = {
        makeArrowImageView()
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        separatorInset = .zero
        
        setupBaseLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func setLayout(for contact: Contact) {
        let firstName = contact.firstName ?? ""
        let lastName = contact.lastName ?? ""
        nameLabel.text = "\(firstName) \(lastName)"
        
        if contact.contactId.isEven {
            setupInitialsPhoto(name: "\(firstName) \(lastName)")
        } else {
            getProfilePhoto()
        }
        
    }
    
    private func setupInitialsPhoto(name: String) {
        let initialsLabel = makeInitialsLabel(name: name)
        photoImageView.image = UIColor.contact_blue.image()
        photoImageView.addSubview(initialsLabel)
        
        initialsLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func getProfilePhoto() {
        AF.request("https://picsum.photos/200/200", method: .get).response{ response in
           switch response.result {
            case .success(let responseData):
                self.photoImageView.image = UIImage(data: responseData!, scale:1)
            case .failure(let error):
                print(error)
            }
        }
    }

}

//MARK: Factory Methods
extension ContactTableViewCell {
    private func makePhotoImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "person.circle")
        imageView.tintColor = .light_blue
        imageView.layer.cornerRadius = 23
        imageView.layer.masksToBounds = true
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(46)
        }
        
        return imageView
    }
    
    private func makeNameLabel() -> UILabel {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 17, weight: .regular)
        return nameLabel
    }
    
    private func makeArrowImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow_right")
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(9)
            make.height.equalTo(16)
        }
        
        return imageView
    }
    
    private func makeInitialsLabel(name: String) -> UILabel {
        let splittedName = name.split(separator: " ")
        var initialsText: String = ""
        _ = splittedName.map {
            initialsText += String($0.first ?? Character(""))
        }
        
        let label = UILabel()
        label.text = initialsText.uppercased()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        return label
    }
}

//MARK: Setup UI
extension ContactTableViewCell {
    private func setupBaseLayout() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(arrowImageView)
        
        photoImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(24).priority(999)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoImageView.snp.trailing).inset(-16)
            make.centerY.equalTo(photoImageView)
            make.trailing.equalTo(arrowImageView.snp.leading).inset(-14)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(photoImageView)
            make .trailing.equalToSuperview().inset(24)
        }
    }
}
