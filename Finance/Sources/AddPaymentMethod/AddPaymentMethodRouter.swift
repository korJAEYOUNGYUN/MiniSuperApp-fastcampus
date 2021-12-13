//
//  AddPaymentMethodRouter.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/15.
//

import ModernRIBs

protocol AddPaymentMethodInteractable: Interactable {
  var router: AddPaymentMethodRouting? { get set }
  var listener: AddPaymentMethodListener? { get set }
}

protocol AddPaymentMethodViewControllable: ViewControllable {
}

final class AddPaymentMethodRouter: ViewableRouter<AddPaymentMethodInteractable, AddPaymentMethodViewControllable>, AddPaymentMethodRouting {
  
  override init(interactor: AddPaymentMethodInteractable, viewController: AddPaymentMethodViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
