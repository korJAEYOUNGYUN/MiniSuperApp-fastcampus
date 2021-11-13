//
//  PaymentMethodView.swift
//  MiniSuperApp
//
//  Created by jaeyoung Yun on 2021/11/13.
//

import UIKit

final class PaymentMethodView: UIView {
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 18, weight: .semibold)
    label.textColor = .white
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 15, weight: .regular)
    label.textColor = .white
    return label
  }()
  
  init(viewModel: PaymentMethodViewModel) {
    super.init(frame: .zero)
    
    setupViews()
    
    nameLabel.text = viewModel.name
    subtitleLabel.text = viewModel.digits
    backgroundColor = viewModel.color
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupViews()
  }
  
  private func setupViews() {
    addSubview(nameLabel)
    addSubview(subtitleLabel)
    
    NSLayoutConstraint.activate([
      nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
      nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
      subtitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

}
