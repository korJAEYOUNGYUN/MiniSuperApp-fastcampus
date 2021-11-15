import ModernRIBs

protocol FinanceHomeDependency: Dependency {
  
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>,
                                    SuperPayDashboardDependency,
                                  CardOnFileDashboardDependency,
                                  AddPaymentMethodDependency {
  let cardOnFileRepository: CardOnfileRepository
  var balance: ReadOnlyCurrentValuePublisher<Double> { balancePublisher }
  
  private let balancePublisher: CurrentValuePublisher<Double>
  
  init(
    dependency: FinanceHomeDependency,
    balance: CurrentValuePublisher<Double>,
    cardOnFileRepository: CardOnfileRepository
  ) {
    self.balancePublisher = balance
    self.cardOnFileRepository = cardOnFileRepository
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
  
  override init(dependency: FinanceHomeDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
    let balancePublisher = CurrentValuePublisher<Double>(0)
    let cardOnFileRepository = CardOnFileRepositoryImp()
    
    let component = FinanceHomeComponent(
      dependency: dependency,
      balance: balancePublisher,
      cardOnFileRepository: cardOnFileRepository
    )
    let viewController = FinanceHomeViewController()
    let interactor = FinanceHomeInteractor(presenter: viewController)
    interactor.listener = listener
    
    let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
    let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
    let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
    
    return FinanceHomeRouter(
      interactor: interactor,
      viewController: viewController,
      superPayDashboardBuildable: superPayDashboardBuilder,
      cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
      addPaymentMethodBuildable: addPaymentMethodBuilder
    )
  }
}
