//
//  ResultViewController.swift
//  MoneyCamera
//
//  Created by wonyoul heo on 6/4/24.
//

import UIKit

class ResultViewController: UITableViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fiftyThousand: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        let billName = UILabel()
        billName.text = "50000원"
        
        let label = UILabel()
        label.text = "0"
        
        let stepper = UIStepper()
        stepper.minimumValue = 0
        stepper.stepValue = 1
        stepper.value = 0
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        
        
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        stackView.addArrangedSubview(billName)
        stackView.addArrangedSubview(spacerView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(stepper)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    var selectedImage: UIImage?
    var totalPrice: Int = 24000
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.separatorStyle = .none
        
        view.backgroundColor = .white
        self.title = "Selected Image"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.contentView.addSubview(imageView)
            if let image = selectedImage {
                imageView.image = image
            } else {
                imageView.image = UIImage(systemName: "face.smiling")
            }
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 350),
                imageView.heightAnchor.constraint(equalToConstant: 350)
                
            ])
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.contentView.addSubview(totalPriceLabel)
            totalPriceLabel.text = "총액: \(totalPrice)원"
            
            let marginGuide = cell.contentView.layoutMarginsGuide
            NSLayoutConstraint.activate([
                totalPriceLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                totalPriceLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
                totalPriceLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor)
            ])
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.contentView.addSubview(fiftyThousand)
            
            let marginGuide = cell.contentView.layoutMarginsGuide
            NSLayoutConstraint.activate([
                fiftyThousand.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                fiftyThousand.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
                fiftyThousand.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor)
            ])
            return cell
            
        default :
            return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row{
        case 0: return 370
        case 1: return 60
        default: return 44.5
        }
    }
    
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        if let label = fiftyThousand.arrangedSubviews[2] as? UILabel {
            label.text = "\(Int(sender.value))"
        }
        totalPrice += 5000
        totalPriceLabel.text = "총액: \(totalPrice)원"
    }
    
}
