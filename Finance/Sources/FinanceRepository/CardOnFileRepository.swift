//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/13.
//

import Foundation
import Combine
import FinanceEntity
import CombineUtil
import Network

public protocol CardOnFileRepository {
  var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
  
  func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error>
  func fetch()
}

public final class CardOnFileRepositoryImp: CardOnFileRepository {
  
  public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodsSubject }
  
  private let network: Network
  private let baseURL: URL
  
  private var cancellables: Set<AnyCancellable>
  
  private let paymentMethodsSubject = CurrentValuePublisher<[PaymentMethod]>([
//    PaymentMethod(id: "0", name: "우리은행", digits: "9123", color: "#f19a38ff", isPrimary: false),
//    PaymentMethod(id: "1", name: "신한은행", digits: "0987", color: "#3478f6ff", isPrimary: false),
//    PaymentMethod(id: "2", name: "현대은행", digits: "8121", color: "#f19a38ff", isPrimary: false)
//    PaymentMethod(id: "3", name: "국민은행", digits: "2812", color: "#65c466ff", isPrimary: false),
//    PaymentMethod(id: "4", name: "카카오뱅크", digits: "8751", color: "#ffcc00ff", isPrimary: false),
  ])
  
  public func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error> {
    let request = AddCardRequest(baseURL: baseURL, info: info)
    
    return network.send(request)
      .map(\.output.card)
      .handleEvents(
        receiveSubscription: nil,
        receiveOutput: { [weak self] method in
          guard let self = self else { return }
          
          self.paymentMethodsSubject.send(self.paymentMethodsSubject.value + [method])
        },
        receiveCompletion: nil,
        receiveCancel: nil,
        receiveRequest: nil
      )
      .eraseToAnyPublisher()
  }
  
  public func fetch() {
    let request = CardOnFileRequest(baseURL: baseURL)
    
    network.send(request)
      .map(\.output.cards)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { [weak self] cards in
          self?.paymentMethodsSubject.send(cards)
        }
      )
      .store(in: &cancellables)
  }
  
  public init(network: Network, baseURL: URL) {
    self.network = network
    self.baseURL = baseURL
    self.cancellables = .init()
  }
}
