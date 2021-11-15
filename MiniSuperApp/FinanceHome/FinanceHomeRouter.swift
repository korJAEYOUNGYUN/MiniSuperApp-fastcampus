import ModernRIBs

protocol FinanceHomeInteractable: Interactable,
                                  SuperPayDashboardListener,
                                  CardOnFileDashboardListener,
                                  AddPaymentMethodListener {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
  var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
  func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
  
  private let superPayDashboardBuildable: SuperPayDashboardBuildable
  private var superPayDashboardRouting: Routing?
  
  private let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
  private var cardOnFileDashboardRouting: Routing?
  
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentMethodRouting: Routing?
  
  init(
    interactor: FinanceHomeInteractable,
    viewController: FinanceHomeViewControllable,
    superPayDashboardBuildable: SuperPayDashboardBuildable,
    cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
    addPaymentMethodBuildable: AddPaymentMethodBuildable
  ) {
    self.superPayDashboardBuildable = superPayDashboardBuildable
    self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachSuperPayDashboard() {
    guard superPayDashboardRouting == nil else { return }
    
    let router = superPayDashboardBuildable.build(withListener: interactor)
    
    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
    
    superPayDashboardRouting = router
    attachChild(router)
  }
  
  func attachCardOnFileDashboard() {
    guard cardOnFileDashboardRouting == nil else { return }
    
    let router = cardOnFileDashboardBuildable.build(withListener: interactor)
    
    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
    
    cardOnFileDashboardRouting = router
    attachChild(router)
  }
  
  func attachAddPaymentMethod() {
    guard addPaymentMethodRouting == nil else { return }
    
    let router = addPaymentMethodBuildable.build(withListener: interactor)
    let navigation = NavigationControllerable(root: router.viewControllable)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    viewControllable.present(navigation, animated: true, completion: nil)
    
    addPaymentMethodRouting = router
    attachChild(router)
  }
  
  func detachAddPaymentMethod() {
    guard let router = addPaymentMethodRouting else { return }
    
    viewControllable.dismiss(completion: nil)
    detachChild(router)
    addPaymentMethodRouting = nil
  }
}
