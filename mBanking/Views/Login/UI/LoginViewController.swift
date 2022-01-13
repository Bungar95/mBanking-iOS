//
//  ViewController.swift
//  mBanking
//
//  Created by Borna Ungar on 11.01.2022..
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
class LoginViewController: UIViewController{
    
    let disposeBag = DisposeBag()
    let dialogController = PinDialogViewController(viewModel: PinDialogViewModelImpl())
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()
    
    let nameTxtField: UITextField = {
        let txtField = UITextField()
        txtField.layer.borderWidth = 1
        txtField.setLeftPadding(5)
        return txtField
    }()
    
    let surnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Surname"
        return label
    }()
    
    let surnameTxtField: UITextField = {
        let txtField = UITextField()
        txtField.layer.borderWidth = 1
        txtField.setLeftPadding(5)
        return txtField
    }()
    
    let submitButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Continue", for: .normal)
        btn.setTitleColor(UIColor.systemRed, for: .disabled)
        btn.setTitleColor(UIColor.systemCyan, for: .normal)
        btn.isEnabled = false
        return btn
    }()
    
    let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.checkUserRegistered()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        dialogController.delegate = self
        initializeButton()
        initializeVM()
    }
}

private extension LoginViewController {
    
    func setupUI(){
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
        view.addSubviews(views: nameLabel, nameTxtField, surnameLabel, surnameTxtField, submitButton)
        nameTxtField.delegate = self
        surnameTxtField.delegate = self
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        nameLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.leading.equalToSuperview().offset(25)
        }
        
        nameTxtField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        surnameLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(nameTxtField.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(25)
        }
        
        surnameTxtField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(surnameLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        submitButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(surnameTxtField.snp.bottom).offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }
    }
    
    func initializeButton() {
        
        submitButton.rx.tap
            .subscribe( onNext: { [unowned self] _ in
                if let userName = nameTxtField.text, let userSurname = surnameTxtField.text {
                    viewModel.userInfoSubject.onNext((userName, userSurname))
                }else{
                    //alert koji kaze da oba moraju biti popunjena
                }
            }).disposed(by: disposeBag)
        
        [nameTxtField, surnameTxtField].forEach{ field in
            field.rx.controlEvent([.editingChanged])
                .asObservable()
                .subscribe(onNext: { [unowned self] _ in
                    if let name = self.nameTxtField.text, let surname = self.surnameTxtField.text {
                        if (!name.isEmpty && !surname.isEmpty){
                            self.submitButton.isEnabled = true
                        }else{
                            self.submitButton.isEnabled = false
                        }
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    
    func initializeVM() {
        disposeBag.insert(self.viewModel.initializeViewModelObservables())
        initializeNameVerificationObservable(subject: viewModel.nameVerificationSubject).disposed(by: disposeBag)
        initializeSuccessfulLoginSubject(subject: viewModel.successLoginSubject).disposed(by: disposeBag)
    }
    
    func initializeNameVerificationObservable(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (verification) in
                if verification {
                    self.present(dialogController, animated: true)
                } else {
                    print("Krivi podaci")
                    nameTxtField.text?.removeAll()
                    surnameTxtField.text?.removeAll()
                    // alert da su krivi podaci
                }
            })
    }
    
    func initializeSuccessfulLoginSubject(subject: ReplaySubject<()>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (verification) in
                navigationController?.pushViewController(OverviewViewController(viewModel: OverviewViewModelImpl(repository: UserRepositoryImpl(networkManager: NetworkManager()))), animated: true)
            })
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var allowedCharacters = CharacterSet.alphanumerics
        allowedCharacters.insert(charactersIn: "-")
        
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else {return false}
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let nonAlphaNumericCharacters = updatedText.trimmingCharacters(in: allowedCharacters)
        
        return (updatedText.count <= 30 && nonAlphaNumericCharacters.count == 0)
    }
    
}

extension LoginViewController: LoginDelegate {
    func successfulLogin(_ success: Bool) {
        if(success){
            nameTxtField.text?.removeAll()
            surnameTxtField.text?.removeAll()
            submitButton.isEnabled = false
            self.viewModel.successLoginSubject.onNext(())
        }
    }
}
