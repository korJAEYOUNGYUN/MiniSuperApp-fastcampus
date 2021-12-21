//
//  File.swift
//  
//
//  Created by jaeyoung Yun on 2021/12/20.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
