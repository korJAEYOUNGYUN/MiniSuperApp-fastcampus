//
//  File.swift
//  
//
//  Created by jaeyoung Yun on 2021/12/26.
//

import Foundation
import Network
import FinanceEntity

struct CardOnFileRequest: Request {
  typealias Output = CardOnFileResponse
  
  let endpoint: URL
  let method: HTTPMethod
  let query: QueryItems
  let header: HTTPHeader
  
  init(baseURL: URL) {
    self.endpoint = baseURL.appendingPathComponent("/cards")
    self.method = .get
    self.query = .init()
    self.header = .init()
  }
}

struct CardOnFileResponse: Decodable {
  let cards: [PaymentMethod]
}
