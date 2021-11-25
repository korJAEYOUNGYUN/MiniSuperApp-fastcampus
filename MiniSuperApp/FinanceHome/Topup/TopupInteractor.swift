//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/22.
//

import ModernRIBs

protocol TopupRouting: Routing {
  func cleanupViews()
  func attachAddPaymentMethod()
  func detachAddPaymentMethod()
  func attachEnterAmount()
  func detachEnterAmount()
  func attachCardOnFile(paymentMethods: [PaymentMethod])
  func detachCardOnFile()
}

protocol TopupListener: AnyObject {
  func topupDidClose()
}

protocol TopupInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor {
  
  weak var router: TopupRouting?
  weak var listener: TopupListener?
  
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
  private var paymenntMethods: [PaymentMethod] {
    return dependency.cardOnFileRepository.cardOnFile.value
  }
  
  private let dependency: TopupInteractorDependency
  
  init(dependency: TopupInteractorDependency) {
    self.dependency = dependency
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    super.init()
    presentationDelegateProxy.delegate = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    if let card = dependency.cardOnFileRepository.cardOnFile.value.first {
      dependency.paymentMethodStream.send(card)
      router?.attachEnterAmount()
    } else {
      router?.attachAddPaymentMethod()
      
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
    
    router?.cleanupViews()
  }
}

// MARK: - AdaptivePresentationControllerDelegate

extension TopupInteractor: AdaptivePresentationControllerDelegate {
  
  func presentationControllerDidDismiss() {
    listener?.topupDidClose()
  }
}

// MARK: - TopupInteractable

extension TopupInteractor: TopupInteractable {
  func addPaymentMethodDidTapClose() {
    router?.detachAddPaymentMethod()
    listener?.topupDidClose()
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
    
  }
  
  func enterAmountDidTapClose() {
    router?.detachEnterAmount()
    listener?.topupDidClose()
  }
  
  func enterAmountDidTapPaymentMethod() {
    router?.attachCardOnFile(paymentMethods: paymenntMethods)
  }
  
  func cardOnFileDidTapClose() {
    router?.detachCardOnFile()
  }
  
  func cardOnFileDidTapAddCard() {
    
  }
  
  func cardOnFileDidSelect(at index: Int) {
    if let selected = paymenntMethods[safe: index] {
      dependency.paymentMethodStream.send(selected)
    }
    router?.detachCardOnFile()
  }
}
