//
//  AddPaymentMethodInteractor.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/15.
//

import ModernRIBs
import Combine

protocol AddPaymentMethodRouting: ViewableRouting {
}

protocol AddPaymentMethodPresentable: Presentable {
  var listener: AddPaymentMethodPresentableListener? { get set }
}

protocol AddPaymentMethodListener: AnyObject {
  func addPaymentMethodDidTapClose()
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod)
}

protocol AddPaymentMethodInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodInteractor: PresentableInteractor<AddPaymentMethodPresentable> {
  
  weak var router: AddPaymentMethodRouting?
  weak var listener: AddPaymentMethodListener?
  
  private let dependency: AddPaymentMethodInteractorDependency
  
  private var cancellables: Set<AnyCancellable>
  
  init(
    presenter: AddPaymentMethodPresentable,
    dependency: AddPaymentMethodInteractorDependency
  ) {
    self.dependency = dependency
    self.cancellables = .init()
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
  
  func didTapConfirm(with number: String, cvc: String, expiry: String) {
    let info = AddPaymentMethodInfo(number: number, cvc: cvc, expiration: expiry)
    dependency.cardOnFileRepository.addCard(info: info)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { [weak self] method in
          self?.listener?.addPaymentMethodDidAddCard(paymentMethod: method)
      })
      .store(in: &cancellables)
  }
}
