//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/25.
//

import ModernRIBs

protocol EnterAmountRouting: ViewableRouting {
  
}

protocol EnterAmountPresentable: Presentable {
  var listener: EnterAmountPresentableListener? { get set }
}

protocol EnterAmountListener: AnyObject {
  func enterAmountDidTapClose()
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable> {
  
  weak var router: EnterAmountRouting?
  weak var listener: EnterAmountListener?
  
  override init(presenter: EnterAmountPresentable) {
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

// MARK: - EnterAmountInteractable

extension EnterAmountInteractor: EnterAmountInteractable {
  
}

// MARK: - EnterAmountPresentableListener

extension EnterAmountInteractor: EnterAmountPresentableListener {
  func didTapClose() {
    listener?.enterAmountDidTapClose()
  }
  
  func didTapPaymentMethod() {
    
  }
  
  func didTapTopup(with amount: Double) {
    
  }
}
