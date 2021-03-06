//
//  OverviewViewController.swift
//  mBanking
//
//  Created by Borna Ungar on 12.01.2022..
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
class OverviewViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let progressView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        return view
    }()
    
    let userContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let userTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome,"
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.quicksandBold(size: 18)
        return label
    }()
    
    let transactionTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        return view
    }()
    
    let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "Current account"
        label.font = R.font.quicksandRegular(size: 18)
        return label
    }()
    
    let accountIBANLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let accountAmountLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.quicksandMedium(size: 18)
        return label
    }()
    
    let changeAccountButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Change", for: .normal)
        btn.setTitleColor(.systemCyan, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        return btn
    }()
    
    let logoutButton: UIButton = {
        let btn = UIButton(type: .close)
        return btn
    }()
    
    let viewModel: OverviewViewModel
    
    init(viewModel: OverviewViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        initializeButtons()
        initializeVM()
        viewModel.loadUserDataSubject.onNext(())
    }
}

private extension OverviewViewController {
    
    func setupUI() {
        navigationItem.titleView?.removeFromSuperview()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
        navigationItem.hidesBackButton = true
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        view.addSubviews(views: progressView, userContainerView, transactionTableView)
        userContainerView.addSubviews(views: nameLabel, userTitleLabel, accountLabel, changeAccountButton, accountIBANLabel, accountAmountLabel, logoutButton)
        
        nameLabel.text = viewModel.userName
        
        view.bringSubviewToFront(progressView)
        view.backgroundColor = .white
        setupConstraints()
    }
    
    func setupConstraints() {
        
        progressView.snp.makeConstraints{ (make) -> Void in
            make.centerX.centerY.equalToSuperview()
        }
        
        userContainerView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        userTitleLabel.snp.makeConstraints{ (make) -> Void in
            make.top.leading.equalToSuperview().offset(10)
        }
        
        nameLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(userTitleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
        }
        
        accountLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        changeAccountButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.centerY.equalTo(accountLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(100)
        }
        
        accountIBANLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(accountLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        accountAmountLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(accountIBANLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
        }
        
        transactionTableView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(userContainerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupTableView() {
        registerCells()
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
    }
    
    func registerCells() {
        transactionTableView.register(OverviewTableViewCell.self, forCellReuseIdentifier: "overviewTableViewCell")
    }
    
    func initializeButtons(){
        
        changeAccountButton.rx.tap
            .subscribe( onNext: { [unowned self] _ in
                let dialogController = AccountsViewController(viewModel: AccountsViewModelImpl(accounts: viewModel.userAccounts))
                dialogController.delegate = self
                self.navigationController?.present(dialogController, animated: true)
            }).disposed(by: disposeBag)
        
    }
    
    @objc func logoutButtonTapped() {
        let alert = UIAlertController(title: "Logout?", message: "You will be send back to the Login screen.", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Logout", style: UIAlertAction.Style.default, handler: { [unowned self] _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func initializeVM(){
        disposeBag.insert(viewModel.initializeViewModelObservables())
        
        initializeLoaderObservable(subject: viewModel.loaderSubject).disposed(by: disposeBag)
        
        initializeTransactionDataObservable(subject: viewModel.currentAccountTransactionsRelay).disposed(by: disposeBag)
    }
    
    func initializeLoaderObservable(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (status) in
                if status {
                    showLoader()
                } else {
                    hideLoader()
                }
            })
    }
    
    func initializeTransactionDataObservable(subject: BehaviorRelay<[[Transaction]]>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (transactions) in
                if let iban = self.viewModel.accountIBAN, let amount = self.viewModel.accountAmount, let currency = self.viewModel.accountCurrency {
                    accountLabel.text = self.viewModel.accountName
                    accountIBANLabel.text = iban
                    accountAmountLabel.text = "\(amount) \(currency)"
                }
                
                if !transactions.isEmpty {
                    transactionTableView.reloadData()
                }
            })
    }
}

extension OverviewViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.currentAccountTransactionsRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.viewModel.isSectionHidden(section) {
            return 0
        }
        
        return viewModel.currentAccountTransactionsRelay.value[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView()
        let sectionLabel = UILabel()
        let sectionButton = UIButton(type: .system)
        
        sectionView.addSubviews(views: sectionLabel, sectionButton)
        sectionView.backgroundColor = .systemCyan
        sectionLabel.textColor = .white
        sectionLabel.font = R.font.quicksandBold(size: 20)
        sectionButton.setTitle(self.viewModel.isSectionHidden(section) ? "Expand" : "Collapse", for: .normal)
        sectionButton.setTitleColor(.white, for: .normal)
        sectionLabel.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
        }
        sectionButton.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-25)
        }
        
        let date = DateUtils.getDateOfDottedString(viewModel.currentAccountTransactionsRelay.value[section][0].date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let resultDate = dateFormatter.string(from: date)
        sectionLabel.text = resultDate
        
        sectionButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.transactionTableView.beginUpdates()
                var indexPaths = [IndexPath]()
                
                for row in viewModel.currentAccountTransactionsRelay.value[section].indices {
                    let indexPath = IndexPath(row: row, section: section)
                    indexPaths.append(indexPath)
                }
                
                if self.viewModel.isSectionHidden(section){
                    tableView.insertRows(at: indexPaths, with: .fade)
                }else{
                    tableView.deleteRows(at: indexPaths, with: .fade)
                }
                
                self.viewModel.hideSection(section)
                sectionButton.setTitle(self.viewModel.isSectionHidden(section) ? "Expand" : "Collapse", for: .normal)
                self.transactionTableView.endUpdates()
            }).disposed(by: disposeBag)
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let transactionCell = tableView.dequeueReusableCell(withIdentifier: "overviewTableViewCell", for: indexPath) as? OverviewTableViewCell else {
            print("failed to dequeue the wanted cell")
            return UITableViewCell()
        }
        
        let transaction = viewModel.currentAccountTransactionsRelay.value[indexPath.section][indexPath.row]
        
        transactionCell.configureCell(description: transaction.description, date: transaction.date, amount: transaction.amount)
        
        return transactionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let transaction = viewModel.currentAccountTransactionsRelay.value[indexPath.section][indexPath.row]
        print(transaction)
    }
}

extension OverviewViewController {
    
    func showLoader() {
        progressView.isHidden = false
        progressView.startAnimating()
    }
    
    func hideLoader() {
        progressView.isHidden = true
        progressView.stopAnimating()
    }
}

extension OverviewViewController: AccountDelegate {
    func switchAccount(_ account: Account) {
        viewModel.currentAccountSubject.onNext(account)
    }
}
