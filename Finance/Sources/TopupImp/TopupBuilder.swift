//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/22.
//

import ModernRIBs
import FinanceRepository
import AddPaymentMethod
import CombineUtil
import FinanceEntity
import Topup
import CombineSchedulers

public protocol TopupDependency: Dependency {
  var topupBaseViewController: ViewControllable { get }
  var cardOnFileRepository: CardOnFileRepository { get }
  var superPayRepository: SuperPayRepository { get }
  var addPaymentMethodBuildable: AddPaymentMethodBuildable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
}

final class TopupComponent: Component<TopupDependency>,
                            TopupInteractorDependency,
                            EnterAmountDependency,
                            CardOnFileDependency {
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { paymentMethodStream }
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }
  var addPaymentMethodBuildable: AddPaymentMethodBuildable { dependency.addPaymentMethodBuildable }
  var mainQueue: AnySchedulerOf<DispatchQueue> { dependency.mainQueue }
  
  fileprivate var topupBaseViewController: ViewControllable {
    return dependency.topupBaseViewController
  }
  
  let paymentMethodStream: CurrentValuePublisher<PaymentMethod>
  
  init(dependency: TopupDependency, paymetMethodStream: CurrentValuePublisher<PaymentMethod>) {
    self.paymentMethodStream = paymetMethodStream
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

public final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {
  
  public override init(dependency: TopupDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: TopupListener) -> Routing {
    let paymetMethodStream = CurrentValuePublisher(PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false))
    
    let component = TopupComponent(dependency: dependency, paymetMethodStream: paymetMethodStream)
    let interactor = TopupInteractor(dependency: component)
    interactor.listener = listener
    
    let enterAmountBuilder = EnterAmountBuilder(dependency: component)
    let cardOnFileBuilder = CardOnFileBuilder(dependency: component)
    
    return TopupRouter(
      interactor: interactor,
      viewController: component.topupBaseViewController,
      addPaymentMethodBuildable: component.addPaymentMethodBuildable,
      enterAmountBuildable: enterAmountBuilder,
      cardOnFileBuildable: cardOnFileBuilder
    )
  }
}
