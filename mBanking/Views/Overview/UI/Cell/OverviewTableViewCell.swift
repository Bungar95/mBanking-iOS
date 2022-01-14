//
//  OverviewTableViewCell.swift
//  mBanking
//
//  Created by Borna Ungar on 12.01.2022..
//

import Foundation
import UIKit
import SnapKit
class OverviewTableViewCell: UITableViewCell {
    
    let transactionImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.black.cgColor
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.quicksandMedium(size: 18)
        label.textColor = .black
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.quicksandRegular(size: 14)
        label.textColor = .black
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.quicksandMedium(size: 14)
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
    
    func configureCell(description: String, date: String, amount: String) {
        
        transactionImageView.image = UIImage(named: "transaction-list")
        descriptionLabel.text = description
        dateLabel.text = date
        amountLabel.text = amount
        
    }
}

private extension OverviewTableViewCell {
    
    func setupUI() {
        contentView.backgroundColor = .white
        self.backgroundColor = .white
        self.selectionStyle = .default
        
        contentView.addSubviews(views: transactionImageView, descriptionLabel, dateLabel, amountLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        transactionImageView.snp.makeConstraints { (make) -> Void in
            make.top.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(20)
        }
        
        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(transactionImageView.snp.trailing).offset(5)
        }
        
        dateLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(transactionImageView.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
        }
        
        amountLabel.snp.makeConstraints { (make) -> Void in
            make.bottom.trailing.equalToSuperview().offset(-10)
        }
    }
}
