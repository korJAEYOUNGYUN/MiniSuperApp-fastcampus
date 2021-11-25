//
//  Array+Utils.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/25.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}

