//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/22.
//

import ModernRIBs
import AddPaymentMethod
import RIBsUtil
import SuperUI
import FinanceEntity
import Topup

protocol TopupInteractable: Interactable,
                            AddPaymentMethodListener,
                            EnterAmountListener,
                            CardOnFileListener {
  var router: TopupRouting? { get set }
  var listener: TopupListener? { get set }
  var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {
  
  private var navigationControllable: NavigationControllerable?
  
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentMethodRouting: Routing?
  
  private let enterAmountBuildable: EnterAmountBuildable
  private var enterAmountRouting: Routing?
  
  private let cardOnFileBuildable: CardOnFileBuildable
  private var cardOnFileRouting: Routing?
  
  init(
    interactor: TopupInteractable,
    viewController: ViewControllable,
    addPaymentMethodBuildable: AddPaymentMethodBuildable,
    enterAmountBuildable: EnterAmountBuildable,
    cardOnFileBuildable: CardOnFileBuildable
  ) {
    self.viewController = viewController
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    self.enterAmountBuildable = enterAmountBuildable
    self.cardOnFileBuildable = cardOnFileBuildable
    super.init(interactor: interactor)
    interactor.router = self
  }
  
  func cleanupViews() {
    if viewController.uiviewController.presentedViewController != nil, navigationControllable != nil {
      navigationControllable?.dismiss(completion: nil)
    }
  }
  
  // MARK: - Private
  
  private let viewController: ViewControllable
  
  func attachAddPaymentMethod(closeButtonType: DismissButtonType) {
    guard addPaymentMethodRouting == nil else { return }
    
    let router = addPaymentMethodBuildable.build(withListener: interactor, closeButtonType: closeButtonType)
    
    if let navigationControllable = navigationControllable {
      navigationControllable.pushViewController(router.viewControllable, animated: true)
    } else {
      presentInsideNavigation(router.viewControllable)
    }
    attachChild(router)
    addPaymentMethodRouting = router
  }
  
  func detachAddPaymentMethod() {
    guard let router = addPaymentMethodRouting else { return }
    
    navigationControllable?.popViewController(animated: true)
    addPaymentMethodRouting = nil
    detachChild(router)

  }
  
  func attachEnterAmount() {
    guard enterAmountRouting == nil else { return }
    
    let router = enterAmountBuildable.build(withListener: interactor)
    
    if let navigation = navigationControllable {
      navigation.setViewControllers([router.viewControllable])
      resetChildRouting()
    } else {
      presentInsideNavigation(router.viewControllable)
    }
    attachChild(router)
    enterAmountRouting = router
  }
  
  func detachEnterAmount() {
    guard let router = enterAmountRouting else { return }
    
    dismissPresentedNavigation {
      self.enterAmountRouting = nil
      self.detachChild(router)
    }
  }
  
  func attachCardOnFile(paymentMethods: [PaymentMethod]) {
    guard cardOnFileRouting == nil else { return }
    
    let router = cardOnFileBuildable.build(withListener: interactor, paymentMethods: paymentMethods)
    navigationControllable?.pushViewController(router.viewControllable, animated: true)
    cardOnFileRouting = router
    attachChild(router)
  }
  
  func detachCardOnFile() {
    guard let router = cardOnFileRouting else { return }
    
    navigationControllable?.popViewController(animated: true)
    cardOnFileRouting = nil
    detachChild(router)
  }
  
  func popToRoot() {
    navigationControllable?.popToRoot(animated: true)
    resetChildRouting()
  }
  
  private func presentInsideNavigation(_ viewControllable: ViewControllable) {
    let navigation = NavigationControllerable(root: viewControllable)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    navigationControllable = navigation
    viewController.present(navigation, animated: true, completion: nil)
  }
  
  private func dismissPresentedNavigation(completion: (() -> Void)?) {
    guard navigationControllable != nil else { return }
    
    viewController.dismiss(completion: nil)
    navigationControllable = nil
  }
  
  private func resetChildRouting() {
    if let cardOnFileRouting = cardOnFileRouting {
      detachChild(cardOnFileRouting)
      self.cardOnFileRouting = nil
    }
    
    if let addPaymentMethodRouting = addPaymentMethodRouting {
      detachChild(addPaymentMethodRouting)
      self.addPaymentMethodRouting = nil
    }
  }
}
