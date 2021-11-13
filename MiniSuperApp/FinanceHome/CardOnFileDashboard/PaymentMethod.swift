//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/13.
//

import Foundation

struct PaymentMethod: Decodable {
  let id: String
  let name: String
  let digits: String
  let color: String
  let isPrimary: Bool
}
