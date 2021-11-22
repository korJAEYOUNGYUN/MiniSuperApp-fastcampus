//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/22.
//

import ModernRIBs

protocol TopupInteractable: Interactable,
                            AddPaymentMethodListener {
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
  
  init(
    interactor: TopupInteractable,
    viewController: ViewControllable,
    addPaymentMethodBuildable: AddPaymentMethodBuildable
  ) {
    self.viewController = viewController
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
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
  
  func attachAddPaymentMethod() {
    guard addPaymentMethodRouting == nil else { return }
    
    let router = addPaymentMethodBuildable.build(withListener: interactor)
    presentInsideNavigation(router.viewControllable)
    attachChild(router)
    addPaymentMethodRouting = router
  }
  
  func detachAddPaymentMethod() {
    guard let router = addPaymentMethodRouting else { return }
    
    dismissPresentedNavigation {
      self.addPaymentMethodRouting = nil
      self.detachChild(router)
    }
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
}
