//
//  File.swift
//  
//
//  Created by jaeyoung Yun on 2021/12/13.
//

import Foundation

public enum DismissButtonType {
  case back, close
  
  public var iconSystemName: String {
    switch self {
    case .back:
      return "chevron.backward"
    case .close:
      return "xmark"
    }
  }
}
