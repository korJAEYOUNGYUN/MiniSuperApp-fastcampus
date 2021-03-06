//
//  File.swift
//  
//
//  Created by jaeyoung Yun on 2022/01/09.
//

import Foundation
import XCTest
import SnapshotTesting
import FinanceEntity
@testable import TopupImp

final class EnterAmountViewTests: XCTestCase {
  
  func testEnterAmount() {
    // given
    let paymentMethod = PaymentMethod(
      id: "0",
      name: "슈퍼은행",
      digits: "**** 9999",
      color: "#51AF80FF",
      isPrimary: false
    )
    let viewModel = SelectedPaymentMethodViewModel(paymentMethod)
    
    // when
    let sut = EnterAmountViewController()
    sut.updateSelectedPaymentMethod(with: viewModel)
    
    // then
    assertSnapshot(matching: sut, as: .image(on: .iPhoneXsMax))
  }
  
  func testEnterAmountLoading() {
    // given
    let paymentMethod = PaymentMethod(
      id: "0",
      name: "슈퍼은행",
      digits: "**** 9999",
      color: "#51AF80FF",
      isPrimary: false
    )
    let viewModel = SelectedPaymentMethodViewModel(paymentMethod)
    
    // when
    let sut = EnterAmountViewController()
    sut.updateSelectedPaymentMethod(with: viewModel)
    sut.startLoading()
    
    // then
    assertSnapshot(matching: sut, as: .image(on: .iPhoneXsMax))
  }
  
  func testEnterAmountStopLoading() {
    // given
    let paymentMethod = PaymentMethod(
      id: "0",
      name: "슈퍼은행",
      digits: "**** 9999",
      color: "#51AF80FF",
      isPrimary: false
    )
    let viewModel = SelectedPaymentMethodViewModel(paymentMethod)
    
    // when
    let sut = EnterAmountViewController()
    sut.updateSelectedPaymentMethod(with: viewModel)
    sut.startLoading()
    sut.stopLoading()
    
    // then
    assertSnapshot(matching: sut, as: .image(on: .iPhoneXsMax))
  }

}
