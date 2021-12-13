import ModernRIBs
import SuperUI
import FinanceEntity

protocol FinanceHomeRouting: ViewableRouting {
  func attachSuperPayDashboard()
  func attachCardOnFileDashboard()
  func attachAddPaymentMethod()
  func detachAddPaymentMethod()
  func attachTopup()
  func detachTopup()
}

protocol FinanceHomePresentable: Presentable {
  var listener: FinanceHomePresentableListener? { get set }
}

protocol FinanceHomeListener: AnyObject {
}

final class FinanceHomeInteractor: PresentableInteractor<FinanceHomePresentable> {
  
  weak var router: FinanceHomeRouting?
  weak var listener: FinanceHomeListener?
  
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
  override init(presenter: FinanceHomePresentable) {
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    super.init(presenter: presenter)
    presenter.listener = self
    self.presentationDelegateProxy.delegate = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    router?.attachSuperPayDashboard()
    router?.attachCardOnFileDashboard()
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
}

// MARK: - FinanceHomeInteractable

extension FinanceHomeInteractor: FinanceHomeInteractable {
  
  func cardOnFileDashboardDidTapAddPaymentMethod() {
    router?.attachAddPaymentMethod()
  }
  
  func addPaymentMethodDidTapClose() {
    router?.detachAddPaymentMethod()
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
    router?.detachAddPaymentMethod()
  }
  
  func superPayDashboardDidTapTopup() {
    router?.attachTopup()
  }
  
  func topupDidClose() {
    router?.detachTopup()
  }
  
  func topupDidFinish() {
    router?.detachTopup()
  }
}

// MARK: - FinanceHomePresentableListener

extension FinanceHomeInteractor: FinanceHomePresentableListener {
  
}

// MARK: - AdaptivePresentationControllerDelegate

extension FinanceHomeInteractor: AdaptivePresentationControllerDelegate {
  func presentationControllerDidDismiss() {
    router?.detachAddPaymentMethod()
  }
}
