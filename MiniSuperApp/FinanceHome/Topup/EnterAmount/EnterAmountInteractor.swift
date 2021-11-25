//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/25.
//

import ModernRIBs
import Combine

protocol EnterAmountRouting: ViewableRouting {
  
}

protocol EnterAmountPresentable: Presentable {
  var listener: EnterAmountPresentableListener? { get set }
  
  func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
}

protocol EnterAmountListener: AnyObject {
  func enterAmountDidTapClose()
  func enterAmountDidTapPaymentMethod()
}

protocol EnterAmountInteractorDependency {
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable> {
  
  weak var router: EnterAmountRouting?
  weak var listener: EnterAmountListener?
  
  private var cancellables: Set<AnyCancellable>
  private let dependency: EnterAmountInteractorDependency
  
  init(presenter: EnterAmountPresentable, dependency: EnterAmountInteractorDependency) {
    cancellables = .init()
    self.dependency = dependency
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    dependency.selectedPaymentMethod
      .sink { [weak self] paymenntMethod in
        self?.presenter.updateSelectedPaymentMethod(with: .init(paymenntMethod))
      }
      .store(in: &cancellables)
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
}

// MARK: - EnterAmountInteractable

extension EnterAmountInteractor: EnterAmountInteractable {
  
}

// MARK: - EnterAmountPresentableListener

extension EnterAmountInteractor: EnterAmountPresentableListener {
  func didTapClose() {
    listener?.enterAmountDidTapClose()
  }
  
  func didTapPaymentMethod() {
    listener?.enterAmountDidTapPaymentMethod()
  }
  
  func didTapTopup(with amount: Double) {
    
  }
}
