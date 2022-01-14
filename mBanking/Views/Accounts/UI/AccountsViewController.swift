//
//  AccountsViewController.swift
//  mBanking
//
//  Created by Borna Ungar on 13.01.2022..
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
class AccountsViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    weak var delegate: AccountDelegate?
    
    let dialogView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let progressView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        return view
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        return tv
    }()
    
    let viewModel: AccountsViewModel
    
    init(viewModel: AccountsViewModel){
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
        initializeVM()
        viewModel.accountsRelay.accept(viewModel.accounts)
    }
}

private extension AccountsViewController {
    
    func setupUI() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
        modalTransitionStyle = .crossDissolve
        
        view.addSubview(dialogView)
        dialogView.addSubviews(views: tableView, progressView)
        view.bringSubviewToFront(progressView)
        setupConstraints()
    }
    
    func setupConstraints() {
        
        dialogView.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(25)
            make.bottom.equalToSuperview().offset(-100)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        progressView.snp.makeConstraints{ (make) -> Void in
            make.centerX.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints{ (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
    
    func setupTableView() {
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func registerCells() {
        tableView.register(AccountsTableViewCell.self, forCellReuseIdentifier: "accountsTableViewCell")
    }
    
    func initializeVM() {
        
        initializeLoaderObservable(subject: viewModel.loaderSubject).disposed(by: disposeBag)
        initializeAccountDataObservable(subject: viewModel.accountsRelay).disposed(by: disposeBag)
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
    
    func initializeAccountDataObservable(subject: BehaviorRelay<[Account]>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (accounts) in
                if !accounts.isEmpty {
                    tableView.reloadData()
                }
            })
    }
}

extension AccountsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.accountsRelay.value.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let accountCell = tableView.dequeueReusableCell(withIdentifier: "accountsTableViewCell", for: indexPath) as? AccountsTableViewCell else {
            print("failed to dequeue the wanted cell")
            return UITableViewCell()
        }
        
        let account = viewModel.accountsRelay.value[indexPath.row]
        
        accountCell.configureCell(id: account.id, iban: account.iban, amount: account.amount, currency: account.currency)
        return accountCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let account = viewModel.accountsRelay.value[indexPath.row]
        dismiss(animated: true, completion: {
            self.delegate?.switchAccount(account)
        })
    }
}

extension AccountsViewController {
    
    func showLoader() {
        progressView.isHidden = false
        progressView.startAnimating()
    }
    
    func hideLoader() {
        progressView.isHidden = true
        progressView.stopAnimating()
    }
}
