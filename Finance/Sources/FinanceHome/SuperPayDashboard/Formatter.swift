//
//  NumberFormatter.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/11.
//

import Foundation

struct Formatter {
  static let balanceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
}
