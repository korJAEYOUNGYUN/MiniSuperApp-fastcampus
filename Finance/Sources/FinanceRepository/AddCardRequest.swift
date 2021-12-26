//
//  File.swift
//  
//
//  Created by jaeyoung Yun on 2021/12/26.
//

import Foundation
import Network
import FinanceEntity

struct AddCardRequest: Request {
  typealias Output = AddCardResponse
  
  let endpoint: URL
  let method: HTTPMethod
  let query: QueryItems
  let header: HTTPHeader
  
  init(baseURL: URL, info: AddPaymentMethodInfo) {
    self.endpoint = baseURL.appendingPathComponent("/addCard")
    self.method = .post
    self.query = [
      "number": info.number,
      "cvc": info.cvc,
      "expiry": info.expiration
    ]
    self.header = .init()
  }
}

struct AddCardResponse: Decodable {
  let card: PaymentMethod
}
