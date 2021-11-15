//
//  CardOnFileDashboardViewController.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/13.
//

import ModernRIBs
import UIKit

protocol CardOnFileDashboardPresentableListener: AnyObject {
  func didTapAddPaymentMethod()
}

final class CardOnFileDashboardViewController: UIViewController, CardOnFileDashboardPresentable, CardOnFileDashboardViewControllable {
  
  weak var listener: CardOnFileDashboardPresentableListener?
  
  private let headerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.axis = .horizontal
    return stackView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22, weight: .semibold)
    label.text = "카드 및 계좌"
    return label
  }()
  
  private lazy var seeAllButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("전체보기", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.addTarget(self, action: #selector(didTapSeeAllButton), for: .touchUpInside)
    return button
  }()
  
  private let cardOnfileStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.axis = .vertical
    stackView.spacing = 12
    return stackView
  }()
  
  private lazy var addMethodButton: AddPaymentMethodButton = {
    let button = AddPaymentMethodButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.roundCorners()
    button.backgroundColor = .systemGray4
    button.addTarget(self, action: #selector(didTapAddMethodButton), for: .touchUpInside)
    return button
  }()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func setupViews() {
    view.addSubview(headerStackView)
    view.addSubview(cardOnfileStackView)
    
    headerStackView.addArrangedSubview(titleLabel)
    headerStackView.addArrangedSubview(seeAllButton)
        
    NSLayoutConstraint.activate([
      headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
      headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      cardOnfileStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
      cardOnfileStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      cardOnfileStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      cardOnfileStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      addMethodButton.heightAnchor.constraint(equalToConstant: 60),
    ])
  }
  
  func update(with viewModels: [PaymentMethodViewModel]) {
    cardOnfileStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    
    let views = viewModels.map(PaymentMethodView.init)
    views.forEach {
      $0.roundCorners()
      cardOnfileStackView.addArrangedSubview($0)
    }
    
    cardOnfileStackView.addArrangedSubview(addMethodButton)
    
    let heightConstraints = views.map { $0.heightAnchor.constraint(equalToConstant: 60) }
    NSLayoutConstraint.activate(heightConstraints)
  }

  @objc
  private func didTapSeeAllButton() {
    
  }
  
  @objc
  private func didTapAddMethodButton() {
    listener?.didTapAddPaymentMethod()
  }
}
