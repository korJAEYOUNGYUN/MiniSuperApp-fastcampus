//
//  SuperPayDashboardBuilder.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/02.
//

import Foundation
import ModernRIBs
import CombineUtil

protocol SuperPayDashboardDependency: Dependency {
  var balance: ReadOnlyCurrentValuePublisher<Double> { get }
}

final class SuperPayDashboardComponent: Component<SuperPayDashboardDependency>, SuperPayDashboardInteractorDependency {
  var balance: ReadOnlyCurrentValuePublisher<Double> { dependency.balance }
  var balanceFormatter: NumberFormatter { Formatter.balanceFormatter }
}

// MARK: - Builder

protocol SuperPayDashboardBuildable: Buildable {
  func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting
}

final class SuperPayDashboardBuilder: Builder<SuperPayDashboardDependency>, SuperPayDashboardBuildable {
  
  override init(dependency: SuperPayDashboardDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting {
    let component = SuperPayDashboardComponent(dependency: dependency)
    let viewController = SuperPayDashboardViewController()
    let interactor = SuperPayDashboardInteractor(
      presenter: viewController,
      dependency: component
    )
    interactor.listener = listener
    return SuperPayDashboardRouter(interactor: interactor, viewController: viewController)
  }
}
