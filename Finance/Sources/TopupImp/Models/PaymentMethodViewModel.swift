//
//  File.swift
//  
//
//  Created by jaeyoung Yun on 2021/12/20.
//

import UIKit
import FinanceEntity

struct PaymentMethodViewModel {
  let name: String
  let digits: String
  let color: UIColor
  
  init(_ paymentMethod: PaymentMethod) {
    name = paymentMethod.name
    digits = "**** \(paymentMethod.digits)"
    color = UIColor(hex: paymentMethod.color) ?? .systemGray2
  }
}
