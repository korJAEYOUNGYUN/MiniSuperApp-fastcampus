//
//  EnterAmountViewController.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/25.
//

import ModernRIBs
import UIKit

protocol EnterAmountPresentableListener: AnyObject {
}

final class EnterAmountViewController: UIViewController, EnterAmountPresentable, EnterAmountViewControllable {
  
  weak var listener: EnterAmountPresentableListener?
}
