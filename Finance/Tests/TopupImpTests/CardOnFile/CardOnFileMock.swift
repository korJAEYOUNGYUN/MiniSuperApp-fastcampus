//
//  File.swift
//  
//
//  Created by jaeyoung Yun on 2022/01/04.
//

import Foundation
@testable import TopupImp
import RIBsTestSupport
import FinanceEntity

final class CardOnFileBuildableMock: CardOnFileBuildable {
  var buildHandler: ((_ listener: CardOnFileListener) -> CardOnFileRouting)?
  
  var buildCallCount = 0
  var buildPaymentMethods: [PaymentMethod]?
  func build(
    withListener listener: CardOnFileListener,
    paymentMethods: [PaymentMethod]
  ) -> CardOnFileRouting {
    buildCallCount += 1
    buildPaymentMethods = paymentMethods
    
    if let buildHandler = buildHandler {
      return buildHandler(listener)
    }
    
    fatalError()
  }
}

final class CardOnFileRoutingMock: ViewableRoutingMock, CardOnFileRouting {
  
}
