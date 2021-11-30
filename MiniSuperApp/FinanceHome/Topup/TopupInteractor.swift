//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/22.
//

import ModernRIBs

protocol TopupRouting: Routing {
  func cleanupViews()
  func attachAddPaymentMethod(closeButtonType: DismissButtonType)
  func detachAddPaymentMethod()
  func attachEnterAmount()
  func detachEnterAmount()
  func attachCardOnFile(paymentMethods: [PaymentMethod])
  func detachCardOnFile()
  func popToRoot()
}

protocol TopupListener: AnyObject {
  func topupDidClose()
  func topupDidFinish()
}

protocol TopupInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor {
  
  weak var router: TopupRouting?
  weak var listener: TopupListener?
  
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
  private var isEnterAmountRoot: Bool = false
  
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
      isEnterAmountRoot = true
      dependency.paymentMethodStream.send(card)
      router?.attachEnterAmount()
    } else {
      isEnterAmountRoot = false
      router?.attachAddPaymentMethod(closeButtonType: .close)
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
    if isEnterAmountRoot == false {
      listener?.topupDidClose()
    }
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
    dependency.paymentMethodStream.send(paymentMethod)
    
    if isEnterAmountRoot {
      router?.popToRoot()
    } else {
      isEnterAmountRoot = true
      router?.attachEnterAmount()
    }
  }
  
  func enterAmountDidTapClose() {
    router?.detachEnterAmount()
    listener?.topupDidClose()
  }
  
  func enterAmountDidTapPaymentMethod() {
    router?.attachCardOnFile(paymentMethods: paymenntMethods)
  }
  
  func enterAmountDidFinishTopup() {
    listener?.topupDidFinish()
  }
  
  func cardOnFileDidTapClose() {
    router?.detachCardOnFile()
  }
  
  func cardOnFileDidTapAddCard() {
    router?.attachAddPaymentMethod(closeButtonType: .back)
  }
  
  func cardOnFileDidSelect(at index: Int) {
    if let selected = paymenntMethods[safe: index] {
      dependency.paymentMethodStream.send(selected)
    }
    router?.detachCardOnFile()
  }
}
