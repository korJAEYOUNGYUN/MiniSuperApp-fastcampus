//
//  CardOnFileRouter.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/25.
//

import ModernRIBs

protocol CardOnFileInteractable: Interactable {
  var router: CardOnFileRouting? { get set }
  var listener: CardOnFileListener? { get set }
}

protocol CardOnFileViewControllable: ViewControllable {
}

final class CardOnFileRouter: ViewableRouter<CardOnFileInteractable, CardOnFileViewControllable>, CardOnFileRouting {
  
  override init(interactor: CardOnFileInteractable, viewController: CardOnFileViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
