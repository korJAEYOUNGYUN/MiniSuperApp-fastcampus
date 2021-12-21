//
//  AppRootComponent.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/12/21.
//

import ModernRIBs
import AppHome
import FinanceHome
import ProfileHome
import FinanceRepository
import TransportHome
import TransportHomeImp
import Topup
import TopupImp
import AddPaymentMethod
import AddPaymentMethodImp

final class AppRootComponent: Component<AppRootDependency>,
                              AppHomeDependency,
                              FinanceHomeDependency,
                              ProfileHomeDependency,
                              TransportHomeDependency,
                              TopupDependency,
                              AddPaymentMethodDependency {
  
  var cardOnFileRepository: CardOnFileRepository
  var superPayRepository: SuperPayRepository
  
  lazy var transportHomeBuildable: TransportHomeBuildable = {
    return TransportHomeBuilder(dependency: self)
  }()
  
  lazy var topupBuildable: TopupBuildable = {
    return TopupBuilder(dependency: self)
  }()
  var topupBaseViewController: ViewControllable { rootViewController.topViewControllable }
  
  lazy var addPaymentMethodBuildable: AddPaymentMethodBuildable = {
    return AddPaymentMethodBuilder(dependency: self)
  }()
  
  private let rootViewController: ViewControllable
  
  init(
    dependency: AppRootDependency,
    cardOnFileRepository: CardOnFileRepository,
    superPayRepository: SuperPayRepository,
    rootViewController: ViewControllable
  ) {
    self.cardOnFileRepository = cardOnFileRepository
    self.superPayRepository = superPayRepository
    self.rootViewController = rootViewController
    super.init(dependency: dependency)
  }
}
