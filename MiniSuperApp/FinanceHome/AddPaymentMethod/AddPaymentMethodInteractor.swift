//
//  AddPaymentMethodInteractor.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/15.
//

import ModernRIBs

protocol AddPaymentMethodRouting: ViewableRouting {
}

protocol AddPaymentMethodPresentable: Presentable {
  var listener: AddPaymentMethodPresentableListener? { get set }
}

protocol AddPaymentMethodListener: AnyObject {
  func addPaymentMethodDidTapClose()
}

final class AddPaymentMethodInteractor: PresentableInteractor<AddPaymentMethodPresentable> {
  
  weak var router: AddPaymentMethodRouting?
  weak var listener: AddPaymentMethodListener?
  
  override init(presenter: AddPaymentMethodPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
}

// MARK: - AddPaymentMethodInteractable

extension AddPaymentMethodInteractor: AddPaymentMethodInteractable {
  
}

// MARK: - AddPaymentMethodPresentableListener

extension AddPaymentMethodInteractor: AddPaymentMethodPresentableListener {
  func didTapClose() {
    listener?.addPaymentMethodDidTapClose()
  }
}
