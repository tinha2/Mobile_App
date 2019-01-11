//
//  PaymentViewModel.swift
//  TrendsAI
//
//  Created by Nguyen Manh Tuan on 1/8/19.
//  Copyright © 2019 Nguyen Manh Tuan. All rights reserved.
//

import Foundation
import RxSwift
import StoreKit

final class PaymentViewModel: BaseViewModel {
    
    var validProducts: [SKProduct] = []
    let productIds = ["TrendsAI.OneWeak", "TrendsAI.OneMonth", "TrendsAI.Year"]
    var productsRequest: SKProductsRequest?
    
    let errors = PublishSubject<String>()
    let paymentTransaction = PublishSubject<SKPaymentTransaction>()
    let paymentSuccess = PublishSubject<String>()
    
    var purchaseProduct: Product?
    
    enum Language: String {
        case alertCannotPayment = "PaymentViewController.Alert.PaymentNotAvailable"
        case alertPaymentSuccess = "PaymentViewController.Alert.PaymentSuccess"
    }
    
    func fetchAvailableProducts() {
        let productIdentifiers = Set(productIds)
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    func purcharseProduct(_ product: Product) {
        guard canMakePurchases(), validProducts.count > product.rawValue else {
            errors.onNext(Language.alertCannotPayment.rawValue.localized())
            return 
        }
        let skProduct = validProducts[product.rawValue]
        let payment = SKPayment(product: skProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
}

extension PaymentViewModel {
    private func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    private func savePaymentInfo() {
        // to do savePaymentInfo
        paymentSuccess.onNext(Language.alertPaymentSuccess.rawValue.localized())
    }
}

extension PaymentViewModel:  SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        validProducts = response.products
        for product in validProducts {
            print("product id \(product.productIdentifier) price : \(product.price)")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            paymentTransaction.onNext(transaction)
            switch transaction.transactionState {
            case .purchasing:
                print("Purchasing")
            case .purchased:
                print("purchased")
                savePaymentInfo()
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("restored")
            case .failed:
                print("failed")
            case .deferred:
                break
            }
        }
    }
}
