//
//  AppRootComponent.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/12/21.
//

import Foundation
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
import Network
import NetworkImp
import CombineSchedulers

final class AppRootComponent: Component<AppRootDependency>,
                              AppHomeDependency,
                              FinanceHomeDependency,
                              ProfileHomeDependency,
                              TransportHomeDependency,
                              TopupDependency,
                              AddPaymentMethodDependency {
  var cardOnFileRepository: CardOnFileRepository
  var superPayRepository: SuperPayRepository
  var mainQueue: AnySchedulerOf<DispatchQueue> { .main }
  
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
    rootViewController: ViewControllable
  ) {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [SuperAppURLProtocol.self]
    setupURLProtocol()
    
    let network = NetworkImp(session: .init(configuration: config))
    
    self.cardOnFileRepository = CardOnFileRepositoryImp(network: network, baseURL: BaseURL().financeBaseURL)
    cardOnFileRepository.fetch()
    self.superPayRepository = SuperPayRepositoryImp(network: network, baseURL: BaseURL().financeBaseURL)
    self.rootViewController = rootViewController
    super.init(dependency: dependency)
  }
}
