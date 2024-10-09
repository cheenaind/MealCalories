//
//  MainCollectionViewCell.swift
//  MealCalories
//
//  Created by Kuandik Chingiz on 09.10.24.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .text01
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.textColor = .text02
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInitialLayout()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
    func setupData(_ data: Food) {
        titleLabel.text = data.description
        let score = Int(data.score ?? 0)
        descriptionLabel.text = "\(data.brandName ?? "") - kCal: \(score)"
    }
    
    private func setupInitialLayout() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    private func configureView() {
        contentView.backgroundColor = .background02
    }
}
