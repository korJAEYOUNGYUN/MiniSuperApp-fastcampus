//
//  File.swift
//  
//
//  Created by jaeyoung Yun on 2021/12/21.
//

import ModernRIBs

public protocol TopupBuildable: Buildable {
  func build(withListener listener: TopupListener) -> Routing
}

public protocol TopupListener: AnyObject {
  func topupDidClose()
  func topupDidFinish()
}
