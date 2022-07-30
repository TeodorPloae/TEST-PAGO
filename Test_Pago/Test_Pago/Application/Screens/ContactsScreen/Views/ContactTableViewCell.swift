//
//  ContactTableViewCell.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 30.07.2022.
//

import UIKit
import SnapKit

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
    
    func setLayout(for contact: Contact) {
        let firstName = contact.firstName ?? ""
        let lastName = contact.lastName ?? ""
        nameLabel.text = "\(firstName) \(lastName)"
    }

}

//MARK: Factory Methods
extension ContactTableViewCell {
    private func makePhotoImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = .checkmark
        imageView.layer.cornerRadius = 23
        
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
