//
//  CardOnFileBuilder.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/25.
//

import ModernRIBs

protocol CardOnFileDependency: Dependency {
}

final class CardOnFileComponent: Component<CardOnFileDependency> {
  
}

// MARK: - Builder

protocol CardOnFileBuildable: Buildable {
  func build(withListener listener: CardOnFileListener, paymentMethods: [PaymentMethod]) -> CardOnFileRouting
}

final class CardOnFileBuilder: Builder<CardOnFileDependency>, CardOnFileBuildable {
  
  override init(dependency: CardOnFileDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: CardOnFileListener, paymentMethods: [PaymentMethod]) -> CardOnFileRouting {
    let component = CardOnFileComponent(dependency: dependency)
    let viewController = CardOnFileViewController()
    let interactor = CardOnFileInteractor(presenter: viewController, paymentMethods: paymentMethods)
    interactor.listener = listener
    return CardOnFileRouter(interactor: interactor, viewController: viewController)
  }
}
