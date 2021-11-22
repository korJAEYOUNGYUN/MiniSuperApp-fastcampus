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
}

protocol TopupListener: AnyObject {
  func topupDidClose()
}

protocol TopupInteractorDependency {
  
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class TopupInteractor: Interactor {
  
  weak var router: TopupRouting?
  weak var listener: TopupListener?
  
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
  private let dependency: TopupInteractorDependency
  
  init(dependency: TopupInteractorDependency) {
    self.dependency = dependency
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    super.init()
    presentationDelegateProxy.delegate = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    if dependency.cardOnFileRepository.cardOnFile.value.isEmpty {
      router?.attachAddPaymentMethod()
    } else {
      
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
}
