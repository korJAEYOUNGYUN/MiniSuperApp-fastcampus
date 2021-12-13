//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/13.
//

import ModernRIBs
import Combine
import FinanceRepository

protocol CardOnFileDashboardRouting: ViewableRouting {
}

protocol CardOnFileDashboardPresentable: Presentable {
  var listener: CardOnFileDashboardPresentableListener? { get set }
  
  func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileDashboardListener: AnyObject {
  func cardOnFileDashboardDidTapAddPaymentMethod()
}

protocol CardOnfileDashboardInteractorDepenedency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable> {
  
  weak var router: CardOnFileDashboardRouting?
  weak var listener: CardOnFileDashboardListener?
  
  private let dependency: CardOnfileDashboardInteractorDepenedency
  private var cancellables = Set<AnyCancellable>()
  
  init(
    presenter: CardOnFileDashboardPresentable,
    dependency: CardOnfileDashboardInteractorDepenedency
  ) {
    self.dependency = dependency
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    dependency.cardOnFileRepository.cardOnFile
      .sink { methods in
        let viewModels = methods.prefix(5).map(PaymentMethodViewModel.init)
        self.presenter.update(with: viewModels)
      }
      .store(in: &cancellables)
  }
  
  override func willResignActive() {
    super.willResignActive()
    
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
  }
}

// MARK: - CardOnFileDashboardInteractable

extension CardOnFileDashboardInteractor: CardOnFileDashboardInteractable {
  
}

// MARK: - CardOnFileDashboardPresentableListener

extension CardOnFileDashboardInteractor: CardOnFileDashboardPresentableListener {
  
  func didTapAddPaymentMethod() {
    listener?.cardOnFileDashboardDidTapAddPaymentMethod()
  }
}
