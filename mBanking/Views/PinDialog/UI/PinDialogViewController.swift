//
//  PinDialogViewController.swift
//  mBanking
//
//  Created by Borna Ungar on 11.01.2022..
//

import Foundation
import UIKit
import RxSwift

class PinDialogViewController: UIViewController {
    
    let disposeBag: DisposeBag
    
    let dialogView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let infoContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Register"
        return label
    }()
    
    let pinTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter a new pin code"
        return label
    }()
    
    let pinNumberTextField: UITextField = {
        let txtField = UITextField()
        txtField.inputView = UIView()
        txtField.inputAccessoryView = UIView()
        txtField.isSecureTextEntry = true
        txtField.layer.borderWidth = 1
        txtField.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        txtField.setLeftPadding(5)
        return txtField
    }()
    
    let verticalStackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .systemGray
        view.distribution = .fillEqually
        view.axis = .vertical
        view.spacing = 30
        return view
    }()
    
    let horizontalStackRow1: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .systemGray
        view.distribution = .fillEqually
        view.axis = .horizontal
        return view
    }()
    
    let horizontalStackRow2: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .systemGray
        view.distribution = .fillEqually
        view.axis = .horizontal
        return view
    }()
    
    let horizontalStackRow3: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .systemGray
        view.distribution = .fillEqually
        view.axis = .horizontal
        return view
    }()
    
    let horizontalStackRow4: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .systemGray
        view.distribution = .fillEqually
        view.axis = .horizontal
        return view
    }()
    
    let button0: UIButton = {
        let btn = UIButton()
        btn.setTitle("0", for: .normal)
        return btn
    }()
    
    let button1: UIButton = {
        let btn = UIButton()
        btn.setTitle("1", for: .normal)
        return btn
    }()
    
    let button2: UIButton = {
        let btn = UIButton()
        btn.setTitle("2", for: .normal)
        return btn
    }()
    
    let button3: UIButton = {
        let btn = UIButton()
        btn.setTitle("3", for: .normal)
        return btn
    }()
    
    let button4: UIButton = {
        let btn = UIButton()
        btn.setTitle("4", for: .normal)
        return btn
    }()
    
    let button5: UIButton = {
        let btn = UIButton()
        btn.setTitle("5", for: .normal)
        return btn
    }()
    
    let button6: UIButton = {
        let btn = UIButton()
        btn.setTitle("6", for: .normal)
        return btn
    }()
    
    let button7: UIButton = {
        let btn = UIButton()
        btn.setTitle("7", for: .normal)
        return btn
    }()
    
    let button8: UIButton = {
        let btn = UIButton()
        btn.setTitle("8", for: .normal)
        return btn
    }()
    
    let button9: UIButton = {
        let btn = UIButton()
        btn.setTitle("9", for: .normal)
        return btn
    }()
    
    let buttonCancel: UIButton = {
        let btn = UIButton()
        btn.setTitle("X", for: .normal)
        return btn
    }()
    
    let buttonOK: UIButton = {
        let btn = UIButton()
        btn.setTitle("OK", for: .normal)
        return btn
    }()
    
    let viewModel: PinDialogViewModel

    init(viewModel: PinDialogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initializeButtons()
    }
    
    func setupUI() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        modalTransitionStyle = .crossDissolve
        
        view.addSubview(dialogView)
        dialogView.addSubviews(views: infoContainerView, verticalStackView)
        infoContainerView.addSubviews(views: titleLabel, pinTitleLabel, pinNumberTextField)
        
        verticalStackView.addArrangedSubview(horizontalStackRow1)
        verticalStackView.addArrangedSubview(horizontalStackRow2)
        verticalStackView.addArrangedSubview(horizontalStackRow3)
        verticalStackView.addArrangedSubview(horizontalStackRow4)
        
        horizontalStackRow1.addArrangedSubview(button1)
        horizontalStackRow1.addArrangedSubview(button2)
        horizontalStackRow1.addArrangedSubview(button3)
        
        horizontalStackRow2.addArrangedSubview(button4)
        horizontalStackRow2.addArrangedSubview(button5)
        horizontalStackRow2.addArrangedSubview(button6)
        
        horizontalStackRow3.addArrangedSubview(button7)
        horizontalStackRow3.addArrangedSubview(button8)
        horizontalStackRow3.addArrangedSubview(button9)
        
        horizontalStackRow4.addArrangedSubview(buttonCancel)
        horizontalStackRow4.addArrangedSubview(button0)
        horizontalStackRow4.addArrangedSubview(buttonOK)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        dialogView.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview().offset(25)
            make.bottom.equalToSuperview().offset(-50)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        infoContainerView.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        verticalStackView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(infoContainerView.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        pinTitleLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(25)
        }
        
        pinNumberTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(pinTitleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func initializeButtons(){
        
        let numericButtons = [button0, button1, button2, button3, button4, button5, button6, button7, button8, button9]
        
        numericButtons.forEach{ button in
            button.rx.tap
                .subscribe( onNext: { [unowned self] _ in
                    if let buttonText = button.titleLabel?.text {
                        self.pinNumberTextField.text?.append(buttonText)
                    }
                }).disposed(by: disposeBag)
        }
        
        buttonCancel.rx.tap
            .subscribe( onNext: { [unowned self] _ in
                    self.pinNumberTextField.text?.removeLast()
            }).disposed(by: disposeBag)
    }
}

extension PinDialogViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else {return false}
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 6
        
    }
    
}
