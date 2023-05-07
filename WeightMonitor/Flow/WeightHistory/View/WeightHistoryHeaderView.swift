//
//  CurrentWeightView.swift
//  WeightMonitor
//
//  Created by Александр Зиновьев on 04.05.2023.
//

import UIKit

protocol CurrentWeightViewDelegate: AnyObject {
    func isSwitchOn(_ isOn: Bool)
}

final class CurrentWeightView: UIView {
    // MARK: - Public
    weak var delegate: CurrentWeightViewDelegate?
    
    func updateView(_ record: [WeightHistoryCellViewModel]) {
        guard let firstRecord = record.first else {
            return
        }
        updateRecord(firstRecord)
    }
    
    func updateViewOnZeroRecords(_ record: WeightHistoryCellViewModel?) {
        guard let record = record else { return }
        updateRecord(record)
    }
    
    // MARK: - Private
    private let textAboutWeightLabel: UILabel = {
        let textAboutWeightLabel = UILabel()
        textAboutWeightLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        textAboutWeightLabel.textColor = .label
        textAboutWeightLabel.alpha = 0.4
        textAboutWeightLabel.text = "Текущий вес"
        return textAboutWeightLabel
    }()
    
    private let currentWeightLabel: UILabel = {
        // Add currentWeight label to stack view
        let currentWeight = UILabel()
        currentWeight.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        currentWeight.textColor = .label
        
        return currentWeight
    }()
    
    private let weightDifference: UILabel = {
        let weightDifference = UILabel()
        weightDifference.translatesAutoresizingMaskIntoConstraints = false
        weightDifference.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        weightDifference.textColor = .secondaryLabel
        
        return weightDifference
    }()
    
    private let currentUnitSystemSwitch: UISwitch = {
        let currentUnitSystemSwitch = UISwitch()
        currentUnitSystemSwitch.onTintColor = .systemIndigo
        return currentUnitSystemSwitch
    }()
    
    private let nameOfUnitSystemLabel: UILabel = {
        let nameOfUnitSystemLabel = UILabel()
        nameOfUnitSystemLabel.textColor = .label
        return nameOfUnitSystemLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}

private extension CurrentWeightView {
    func setupView() {
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.backgroundColor = .currentWeightBackground
        
        currentUnitSystemSwitch.addTarget(self, action: #selector(handleSwitchChange), for: .touchUpInside)
        
        // Add horizontal stackViewWeight
        let stackViewWeight = UIStackView(arrangedSubviews: [currentWeightLabel, weightDifference])
        stackViewWeight.axis = .horizontal
        stackViewWeight.spacing = 8
        stackViewWeight.alignment = .bottom
        
        // Add horizontal stackViewUnitSystem
        let stackViewUnitSystem = UIStackView(arrangedSubviews: [currentUnitSystemSwitch, nameOfUnitSystemLabel])
        stackViewUnitSystem.axis = .horizontal
        stackViewUnitSystem.spacing = 16
        stackViewUnitSystem.alignment = .center
        
        // Add container for weightImage
        let imageView = UIImageView()
        imageView.image = .weightImage
        
        let containerView = UIView()
        containerView.widthAnchor.constraint(equalToConstant: 131).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 82).isActive = true
        containerView.addSubviews(imageView)
        
        
        addSubviews(textAboutWeightLabel, stackViewWeight, stackViewUnitSystem, containerView)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 129),
            self.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
            
            textAboutWeightLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            textAboutWeightLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textAboutWeightLabel.heightAnchor.constraint(equalToConstant: 18),
            
            nameOfUnitSystemLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            stackViewWeight.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackViewWeight.topAnchor.constraint(equalTo: textAboutWeightLabel.bottomAnchor, constant: 6),
            stackViewWeight.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            stackViewUnitSystem.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackViewUnitSystem.topAnchor.constraint(equalTo: stackViewWeight.bottomAnchor, constant: 16),
            stackViewUnitSystem.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackViewUnitSystem.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackViewUnitSystem.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            stackViewUnitSystem.heightAnchor.constraint(equalToConstant: 31)
        ])
        
        NSLayoutConstraint.activate([
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 131),
            containerView.heightAnchor.constraint(equalToConstant: 82),
            
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            imageView.bottomAnchor.constraint(equalTo:  containerView.bottomAnchor, constant: -13)
        ])
    }
    
    @objc func handleSwitchChange() {
        delegate?.isSwitchOn(currentUnitSystemSwitch.isOn)
    }
    
    func updateRecord(_ record: WeightHistoryCellViewModel) {
        UIView.animate(withDuration: 0.3) {
            self.currentWeightLabel.text = record.weight
            self.weightDifference.text = record.weightDifference
            self.nameOfUnitSystemLabel.text = record.currentUnitName
            self.currentUnitSystemSwitch.isOn = record.isSwitchOn
        }
    }
}
