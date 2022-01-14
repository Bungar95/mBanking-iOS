//
//  AccountsTableViewCell.swift
//  mBanking
//
//  Created by Borna Ungar on 13.01.2022..
//

import Foundation
import UIKit
import SnapKit
class AccountsTableViewCell: UITableViewCell {
    
    let transactionImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.black.cgColor
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.quicksandMedium(size: 18)
        label.textColor = .black
        return label
    }()
    
    let ibanLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.quicksandMedium(size: 18)
        label.textColor = .black
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.quicksandRegular(size: 14)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(id: String, iban: String, amount: String, currency: String) {
        
        transactionImageView.image = UIImage(named: "transaction-list")
        nameLabel.text = "Account #\(id)"
        ibanLabel.text = iban
        amountLabel.text = "\(amount) \(currency)"
    }
}

private extension AccountsTableViewCell {
    
    func setupUI() {
        contentView.backgroundColor = .white
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        contentView.addSubviews(views: transactionImageView, nameLabel, ibanLabel, amountLabel)
        setupConstraints()
    }
    
    func setupConstraints() {
        
        transactionImageView.snp.makeConstraints { (make) -> Void in
            make.top.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(20)
        }
        
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-5)
            make.leading.equalTo(transactionImageView.snp.trailing).offset(5)
        }
        
        ibanLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(transactionImageView.snp.bottom).offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.leading.equalToSuperview().offset(10)
        }
        
        amountLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(ibanLabel.snp.bottom).offset(5)
            make.bottom.trailing.equalToSuperview().offset(-10)
        }
    }
}
