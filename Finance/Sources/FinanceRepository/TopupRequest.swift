//
//  File.swift
//  
//
//  Created by jaeyoung Yun on 2021/12/26.
//

import Foundation
import Network

struct TopupRequest: Request {
  typealias Output = TopupResponse
  
  let endpoint: URL
  let method: HTTPMethod
  let query: QueryItems
  let header: HTTPHeader
  
  init(baseURL: URL, amount: Double, paymenntMethodID: String) {
    self.endpoint = baseURL.appendingPathComponent("/topup")
    self.method = .post
    self.query = [
      "amount": amount,
      "paymentMethodID": paymenntMethodID
    ]
    self.header = .init()
  }
}

struct TopupResponse: Decodable {
  let status: String
}
