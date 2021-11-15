//
//  AddPaymentMethodBuilder.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/15.
//

import ModernRIBs

protocol AddPaymentMethodDependency: Dependency {
}

final class AddPaymentMethodComponent: Component<AddPaymentMethodDependency> {
  
}

// MARK: - Builder

protocol AddPaymentMethodBuildable: Buildable {
  func build(withListener listener: AddPaymentMethodListener) -> AddPaymentMethodRouting
}

final class AddPaymentMethodBuilder: Builder<AddPaymentMethodDependency>, AddPaymentMethodBuildable {
  
  override init(dependency: AddPaymentMethodDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: AddPaymentMethodListener) -> AddPaymentMethodRouting {
    let component = AddPaymentMethodComponent(dependency: dependency)
    let viewController = AddPaymentMethodViewController()
    let interactor = AddPaymentMethodInteractor(presenter: viewController)
    interactor.listener = listener
    return AddPaymentMethodRouter(interactor: interactor, viewController: viewController)
  }
}
