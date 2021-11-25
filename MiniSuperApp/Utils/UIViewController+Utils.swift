//
//  UIViewController+Utils.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/25.
//

import UIKit

extension UIViewController {
  func setupNavigationItem(target: Any?, action: Selector?) {
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)),
      style: .plain,
      target: target,
      action: action
    )
  }
}
