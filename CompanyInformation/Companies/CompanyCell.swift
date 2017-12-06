//
//  CompanyCell.swift
//  CompanyInformation
//
//  Created by ashim Dahal on 12/6/17.
//  Copyright © 2017 ashim Dahal. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
   
    var company : Company? {
        didSet {
            
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
            if let name = company?.name , let founded = company?.founded {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd , yyyy"
                let foundedDateString = dateFormatter.string(from: founded)
                companyTextLabel.text = "\(name) - Founded : \(foundedDateString)"
            }else{
                companyTextLabel.text = company?.name
            }
        }
    }
    
    let companyImageView : UIImageView = {
       let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let companyTextLabel : UILabel = {
        let label = UILabel()
        label.text = "Default Company Name"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.tealColor
        setupUI()
    }
    private func setupUI(){
        addSubview(companyImageView)
        addSubview(companyTextLabel)
        constraintForView()
    }
    private func constraintForView(){
        NSLayoutConstraint.activate([companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor), companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant : 15), companyImageView.widthAnchor.constraint(equalToConstant: 50), companyImageView.heightAnchor.constraint(equalToConstant: 50)])
        NSLayoutConstraint.activate([companyTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),companyTextLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 8), companyTextLabel.rightAnchor.constraint(equalTo: rightAnchor),companyTextLabel.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
