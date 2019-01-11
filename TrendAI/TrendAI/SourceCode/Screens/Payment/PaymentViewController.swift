//
//  PaymentViewController.swift
//  TrendsAI
//
//  Created by Nguyen Manh Tuan on 1/8/19.
//  Copyright © 2019 Nguyen Manh Tuan. All rights reserved.
//

import UIKit
import StoreKit
import RxSwift

enum Product: Int {
    case oneWeak
    case oneMonth
    case oneYear
}

class PaymentViewController: BaseViewController {
    
    private var viewModel: PaymentViewModel!
    
    @IBOutlet weak private var oneWeekButton: UIButton!
    @IBOutlet weak private var oneMonthButton: UIButton!
    @IBOutlet weak private var oneYearButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchAvailableProducts()
    }
    
    override func setupViewModel() {
        viewModel = PaymentViewModel()
    }
    
    override func setupRx() {
        viewModel.errors
            .subscribe(onNext: { [weak self] (error) in
                guard let `self` = self else { return }
                self.indicatorView.loading(false)
                self.showAlert(message: error)
            })
            .disposed(by: disposeBag)
        
        viewModel.paymentTransaction
            .subscribe(onNext: { [weak self] (transaction) in
                guard let `self` = self else { return }
                self.transactionDidChange(transaction)
            })
            .disposed(by: disposeBag)
        
        viewModel.paymentSuccess
            .subscribe(onNext: { [weak self] result in
                guard let `self` = self else { return }
                self.showAlert(message: result)
            })
            .disposed(by: disposeBag)
        
        let buttons: [UIButton] = [oneWeekButton, oneMonthButton, oneYearButton]
        for tag in 0..<buttons.count {
            let button = buttons[tag]
            button.tag = tag
            button.rx.tap.asObservable()
                .subscribe(onNext: { [weak self] _ in
                    guard let `self` = self,let product = Product(rawValue: button.tag) else { return }
                    self.viewModel.purcharseProduct(product)
                })
                .disposed(by: disposeBag)
        }
        
    }
    
    private func transactionDidChange(_ transaction: SKPaymentTransaction) {
        switch transaction.transactionState {
        case .purchasing:
            print("Purchasing")
            self.indicatorView.loading(true)
        case .purchased:
            print("purchased")
        case .restored:
            print("restored")
        case .failed:
            print("failed")
            self.indicatorView.loading(false)
        case .deferred:
            break
        }
    }
    
}

