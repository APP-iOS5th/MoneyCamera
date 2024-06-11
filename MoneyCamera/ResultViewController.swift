//
//  ResultViewController.swift
//  MoneyCamera
//
//  Created by wonyoul heo on 6/4/24.
//

import UIKit

class ResultViewController: UITableViewController {
    let VisionObjectRecognitionModel = VisionObjectRecognition.shared
    var selectedImage: UIImage?
    
    var fiftyThousandBillInit = 0
    var tenThousandBillInit = 0
    var fiveThousandBillInit = 0
    var oneThousandBillInit = 0
    var totalPrice = 0
    let priceLabel = UILabel()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "계산결과"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var billImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var totalPriceStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        
        let totalLabel = UILabel()
        totalLabel.text = "총액"
        totalLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        priceLabel.text = "\(totalPrice)원"
        priceLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        stackView.addArrangedSubview(totalLabel)
        stackView.addArrangedSubview(priceLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var detailPrice: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "세부사항"
        
        let menuLabelStack = UIStackView()
        menuLabelStack.axis = .horizontal
        menuLabelStack.alignment = .center
        menuLabelStack.distribution = .equalSpacing
        menuLabelStack.translatesAutoresizingMaskIntoConstraints = false
        
        let categoryLabel = UILabel()
        categoryLabel.text = "항목"
        
        let numberLabel = UILabel()
        numberLabel.text = "개수"
        
        menuLabelStack.addArrangedSubview(categoryLabel)
        menuLabelStack.addArrangedSubview(numberLabel)
        
        let fiftyThousandStack = createStepperStackView(billNameInt: 50000, initialBillNumberInt: fiftyThousandBillInit)
        let tenThousandStack = createStepperStackView(billNameInt: 10000, initialBillNumberInt: tenThousandBillInit)
        let fiveThousandStack = createStepperStackView(billNameInt: 5000, initialBillNumberInt: fiveThousandBillInit)
        let oneThousandStack = createStepperStackView(billNameInt: 1000, initialBillNumberInt: oneThousandBillInit)
       
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(menuLabelStack)
        mainStackView.addArrangedSubview(fiftyThousandStack)
        mainStackView.addArrangedSubview(tenThousandStack)
        mainStackView.addArrangedSubview(fiveThousandStack)
        mainStackView.addArrangedSubview(oneThousandStack)
        
        NSLayoutConstraint.activate([
            menuLabelStack.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            menuLabelStack.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            fiftyThousandStack.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            fiftyThousandStack.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            tenThousandStack.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            tenThousandStack.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            fiveThousandStack.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            fiveThousandStack.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            oneThousandStack.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            oneThousandStack.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
        ])
        
        return mainStackView
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "backgroundColor_green")
        
        self.title = "MoneyLens"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        classifyingCurrencies()
        totalAmount()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장하기", style: .plain, target: self, action: #selector(saveTapped))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        VisionObjectRecognitionModel.dictReset()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.contentView.addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.contentView.addSubview(billImage)
            
            if let image = selectedImage {
                billImage.image = image
            } else {
                billImage.image = UIImage(systemName: "questionmark.folder")
            }
            
            NSLayoutConstraint.activate([
                billImage.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                billImage.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                billImage.widthAnchor.constraint(equalToConstant: 350),
                billImage.heightAnchor.constraint(equalToConstant: 350)
            ])
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.contentView.addSubview(totalPriceStack)
            
            let marginGuide = cell.contentView.layoutMarginsGuide
            NSLayoutConstraint.activate([
                totalPriceStack.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                totalPriceStack.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor)
            ])
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.contentView.addSubview(detailPrice)
            
            let marginGuide = cell.contentView.layoutMarginsGuide
            NSLayoutConstraint.activate([
                detailPrice.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                detailPrice.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
                detailPrice.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor)
            ])
            return cell
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1: return 370
        case 2: return 90
        case 3: return 280
        default: return 44.5
        }
    }
    
    private func createStepperStackView(billNameInt: Int, initialBillNumberInt: Int) -> UIStackView {
        let stepperStack = UIStackView()
        stepperStack.axis = .horizontal
        stepperStack.alignment = .center
        stepperStack.distribution = .equalSpacing
        stepperStack.translatesAutoresizingMaskIntoConstraints = false
        
        let billName = UILabel()
        billName.text = "\(billNameInt)원"
        
        let billNumStack = UIStackView()
        billNumStack.axis = .horizontal
        billNumStack.spacing = 5
        
        let billNumber = UILabel()
        billNumber.text = "\(initialBillNumberInt)"
        billNumber.tag = 100
        
        let minusButton = UIButton(type: .custom) 
        var config = UIButton.Configuration.filled()
        config.title = "-"
        config.baseBackgroundColor = UIColor(named: "buttonIconColor_green")
        minusButton.configuration = config
        minusButton.addAction(UIAction { [weak self] _ in
            self?.updateBillNumber(for: billNumStack, increment: -1, billValue: billNameInt)
        }, for: .touchUpInside)
        
        let plusButton = UIButton(type: .custom)
        config.title = "+"
        config.baseBackgroundColor = UIColor(named: "buttonIconColor_green")
        plusButton.configuration = config
        plusButton.addAction(UIAction { [weak self] _ in
            self?.updateBillNumber(for: billNumStack, increment: 1, billValue: billNameInt)
        }, for: .touchUpInside)
        
        billNumStack.addArrangedSubview(minusButton)
        billNumStack.addArrangedSubview(billNumber)
        billNumStack.addArrangedSubview(plusButton)
        
        stepperStack.addArrangedSubview(billName)
        stepperStack.addArrangedSubview(billNumStack)
        
        return stepperStack
    }
    
    func totalAmount() {
        let totalCurrency = 50000 * fiftyThousandBillInit + 10000 * tenThousandBillInit + 5000 * fiveThousandBillInit + 1000 * oneThousandBillInit
        totalPrice = totalCurrency
        priceLabel.text = "\(totalPrice)원"
    }
    
    func classifyingCurrencies() {
        for Currency in VisionObjectRecognitionModel.dict {
            switch Currency.key {
            case "50000won":
                fiftyThousandBillInit = Currency.value
            case "10000won":
                tenThousandBillInit = Currency.value
            case "5000won":
                fiveThousandBillInit = Currency.value
            case "1000won":
                oneThousandBillInit = Currency.value
            default:
                break
            }
            
        }
    }
    
    func updateBillNumber(for stackView: UIStackView, increment: Int, billValue: Int) {
//        if let billNumberLabel = stackView.viewWithTag(100) as? UILabel,
          if let billNumberLabel = stackView.arrangedSubviews.first(where: { $0 is UILabel && $0.tag == 100 }) as? UILabel,

           let currentNumber = Int(billNumberLabel.text ?? "0") {
            let newNumber = currentNumber + increment
            if newNumber >= 0 {
                billNumberLabel.text = "\(newNumber)"
                totalPrice += increment * billValue
                priceLabel.text = "\(totalPrice)원"
            }
        }
    }
    
    @objc private func saveTapped() {
        guard let selectedImage = selectedImage else { return }
        
        let totalAmount = "\(totalPrice)"
    
        let result = CurrencyRecognitionResult(totalAmount: totalAmount, date: Date(), image: selectedImage)
        DataManager.shared.saveResult(result)
        show(HistoryViewController(), sender: nil)
    
    

    }
}
