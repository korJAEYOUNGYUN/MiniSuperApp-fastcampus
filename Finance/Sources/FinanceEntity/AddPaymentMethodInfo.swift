//
//  AddPaymentMethodInfo.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/22.
//

import Foundation

public struct AddPaymentMethodInfo {
  public let number: String
  public let cvc: String
  public let expiration: String
  
  public init(
    number: String,
    cvc: String,
    expiration: String
  ) {
    self.number = number
    self.cvc = cvc
    self.expiration = expiration
  }
}
