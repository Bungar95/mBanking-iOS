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
    
    let tableView: UITableView = {
        let tv = UITableView()
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
        initializeVM()
    }
}

private extension AccountsViewController {

    func setupUI() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        modalTransitionStyle = .crossDissolve
        
        view.addSubviews(views: tableView)
        setupConstraints()
    }
    
    func setupConstraints() {
        
        tableView.snp.makeConstraints{ (make) -> Void in
            make.edges.equalToSuperview().offset(50)
        }
    }
    
    func initializeVM() {
        disposeBag.insert(self.viewModel.initializeViewModelObservables())
//        initializeDialogDismiss(subject: viewModel.dismissSubject).disposed(by: disposeBag)
    }
    
//    func initializeDialogDismiss(subject: ReplaySubject<()>) -> Disposable {
//        return subject
//            .observe(on: MainScheduler.instance)
//            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
//            .subscribe(onNext: { [unowned self] _ in
//                dismiss(animated: true, completion: {
//                    self.delegate?.successfulLogin(true)
//                })
//            })
//        
//    }
    
}
