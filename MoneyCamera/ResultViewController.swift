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
        label.text = "계산결과"
        label.font = UIFont(name: "Pretendard-Regular", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var billImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var totalPriceStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .bottom
        stackView.distribution = .equalSpacing
        
        let totalLabel = UILabel()
        totalLabel.text = "총액"
        totalLabel.font = UIFont(name: "Pretendard-Regular", size: 35)
        
        priceLabel.text = "\(totalPrice)원"
        priceLabel.font = UIFont(name: "Pretendard-Medium", size: 35)
        
        stackView.addArrangedSubview(totalLabel)
        stackView.addArrangedSubview(priceLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var detailPrice: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 15
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let fiftyThousandStack = createStepperStackView(billNameString:"오만원" ,billNameInt: 50000, initialBillNumberInt: fiftyThousandBillInit)
        let tenThousandStack = createStepperStackView(billNameString: "일만원" ,billNameInt: 10000, initialBillNumberInt: tenThousandBillInit)
        let fiveThousandStack = createStepperStackView(billNameString: "오천원" ,billNameInt: 5000, initialBillNumberInt: fiveThousandBillInit)
        let oneThousandStack = createStepperStackView(billNameString: "일천원" ,billNameInt: 1000, initialBillNumberInt: oneThousandBillInit)
       
        mainStackView.addArrangedSubview(fiftyThousandStack)
        mainStackView.addArrangedSubview(tenThousandStack)
        mainStackView.addArrangedSubview(fiveThousandStack)
        mainStackView.addArrangedSubview(oneThousandStack)
        
        NSLayoutConstraint.activate([
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "darkgreen") ?? .black]
        self.navigationController?.navigationBar.tintColor = UIColor(named: "buttonIconColor_green")
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        classifyingCurrencies()
        totalAmount()
        
        let saveButton = UIBarButtonItem(title: "저장하기", style: .plain, target: self, action: #selector(saveTapped))
        saveButton.tintColor = UIColor(named: "buttonIconColor_green")
        navigationItem.rightBarButtonItem = saveButton
        
        
        
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
            cell.backgroundColor = UIColor(named: "backgroundColor_green")
            
            let squareView = UIView()
            squareView.backgroundColor = .white
            squareView.translatesAutoresizingMaskIntoConstraints = false
            
            cell.contentView.addSubview(squareView)
            cell.contentView.addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                squareView.widthAnchor.constraint(equalToConstant: 360),
                squareView.heightAnchor.constraint(equalToConstant: 40),
                squareView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                squareView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 20),
                
                titleLabel.topAnchor.constraint(equalTo: squareView.topAnchor, constant: 15),
                titleLabel.centerXAnchor.constraint(equalTo: squareView.centerXAnchor)
            ])
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "backgroundColor_green")
            
            
            if let image = selectedImage {
                billImage.image = image
            } else {
                billImage.image = UIImage(systemName: "questionmark.folder")
            }
            
            let squareView = UIView()
            squareView.backgroundColor = .white
            squareView.translatesAutoresizingMaskIntoConstraints = false
            

            cell.contentView.addSubview(squareView)
            cell.contentView.addSubview(billImage)

            
            NSLayoutConstraint.activate([
                squareView.widthAnchor.constraint(equalToConstant: 360),
                squareView.heightAnchor.constraint(equalToConstant: 360),
                squareView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                squareView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                
                billImage.centerXAnchor.constraint(equalTo: squareView.centerXAnchor),
                billImage.topAnchor.constraint(equalTo: squareView.topAnchor, constant: 10),
                billImage.widthAnchor.constraint(equalToConstant: 330),
                billImage.heightAnchor.constraint(equalToConstant: 330)
            ])
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "backgroundColor_green")
            
            let squareView = UIView()
            squareView.backgroundColor = .white
            squareView.translatesAutoresizingMaskIntoConstraints = false
            
            let lineImage = UIImageView()
            lineImage.image = UIImage(named: "lineGray")
            lineImage.translatesAutoresizingMaskIntoConstraints = false
            
            cell.contentView.addSubview(squareView)
            cell.contentView.addSubview(totalPriceStack)
            cell.contentView.addSubview(lineImage)
            
            
            NSLayoutConstraint.activate([
                squareView.widthAnchor.constraint(equalToConstant: 360),
                squareView.heightAnchor.constraint(equalToConstant: 70),
                squareView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                squareView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                
                totalPriceStack.topAnchor.constraint(equalTo: squareView.topAnchor),
                totalPriceStack.leadingAnchor.constraint(equalTo: squareView.leadingAnchor, constant: 20),
                totalPriceStack.trailingAnchor.constraint(equalTo: squareView.trailingAnchor, constant:  -20),
                
                lineImage.bottomAnchor.constraint(equalTo: totalPriceStack.bottomAnchor, constant: 15),
                lineImage.leadingAnchor.constraint(equalTo: squareView.leadingAnchor, constant: 15),
                lineImage.trailingAnchor.constraint(equalTo: squareView.trailingAnchor, constant: -15),
                lineImage.heightAnchor.constraint(equalToConstant: 2)
            ])
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "backgroundColor_green")
            
            let squareView = UIView()
            squareView.backgroundColor = .white
            squareView.translatesAutoresizingMaskIntoConstraints = false
            
            
            cell.contentView.addSubview(squareView)
            cell.contentView.addSubview(detailPrice)
            
            
            NSLayoutConstraint.activate([
                squareView.widthAnchor.constraint(equalToConstant: 360),
                squareView.heightAnchor.constraint(equalToConstant: 200),
                squareView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                squareView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                
                detailPrice.topAnchor.constraint(equalTo: squareView.topAnchor,constant: 5),
                detailPrice.leadingAnchor.constraint(equalTo: squareView.leadingAnchor, constant: 20),
                detailPrice.trailingAnchor.constraint(equalTo: squareView.trailingAnchor, constant: -20)
            ])
            return cell
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 60
        case 1: return 360
        case 2: return 70
        case 3: return 200
        default: return 0
        }
    }
    
    private func createStepperStackView(billNameString: String, billNameInt: Int, initialBillNumberInt: Int) -> UIStackView {
        let stepperStack = UIStackView()
        stepperStack.axis = .horizontal
        stepperStack.alignment = .center
        stepperStack.translatesAutoresizingMaskIntoConstraints = false
        
        let billName = UILabel()
        billName.text = "\(billNameString)"
        billName.font = UIFont(name: "Pretendard-Medium", size: 22)
        billName.translatesAutoresizingMaskIntoConstraints = false
        billName.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let billNumber = UILabel()
        billNumber.text = "\(initialBillNumberInt)"
        billNumber.font = UIFont(name: "Pretendard-Regular", size: 20)
        billNumber.translatesAutoresizingMaskIntoConstraints = false
        billNumber.textAlignment = .center
        billNumber.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        let minusButton = UIButton(type: .custom) 
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "minus")
        config.baseBackgroundColor = UIColor(named: "buttonIconColor_green")
        minusButton.configuration = config
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.addAction(UIAction { [weak self] _ in
            self?.updateBillNumber(for: billNumber, increment: -1, billValue: billNameInt)
        }, for: .touchUpInside)
        
        let plusButton = UIButton(type: .custom)
        config.image = UIImage(systemName: "plus")
        config.baseBackgroundColor = UIColor(named: "buttonIconColor_green")
        plusButton.configuration = config
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.addAction(UIAction { [weak self] _ in
            self?.updateBillNumber(for: billNumber, increment: 1, billValue: billNameInt)
        }, for: .touchUpInside)
    
        stepperStack.addArrangedSubview(billName)
        stepperStack.addArrangedSubview(minusButton)
        stepperStack.addArrangedSubview(billNumber)
        stepperStack.addArrangedSubview(plusButton)
        
        NSLayoutConstraint.activate([
            minusButton.widthAnchor.constraint(equalToConstant: 30),
            minusButton.heightAnchor.constraint(equalToConstant: 30),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
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
    
    func updateBillNumber(for billNumber: UILabel, increment: Int, billValue: Int) {
        if let currentNumber = Int(billNumber.text ?? "0"), currentNumber + increment >= 0 {
            let newNumber = currentNumber + increment
            if newNumber >= 0 {
                billNumber.text = "\(newNumber)"
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
