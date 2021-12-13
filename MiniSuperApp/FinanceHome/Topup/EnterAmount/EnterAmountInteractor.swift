//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/25.
//

import ModernRIBs
import Combine
import Foundation
import CombineUtil
import FinanceEntity

protocol EnterAmountRouting: ViewableRouting {
  
}

protocol EnterAmountPresentable: Presentable {
  var listener: EnterAmountPresentableListener? { get set }
  
  func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
  func startLoading()
  func stopLoading()
}

protocol EnterAmountListener: AnyObject {
  func enterAmountDidTapClose()
  func enterAmountDidTapPaymentMethod()
  func enterAmountDidFinishTopup()
}

protocol EnterAmountInteractorDependency {
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
  var superPayRepository: SuperPayRepository { get }
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
    presenter.startLoading()
    
    dependency.superPayRepository.topup(
      amount: amount,
      paymentMethodID: dependency.selectedPaymentMethod.value.id
    )
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] _ in
          self?.presenter.stopLoading()
        }, receiveValue: { [weak self] in
          self?.listener?.enterAmountDidFinishTopup()
        }
      )
      .store(in: &cancellables)
  }
}
