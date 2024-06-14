//
//  ResultViewController.swift
//  MoneyCamera
//
//  Created by wonyoul heo on 6/4/24.
//

import UIKit

class ResultViewController: UIViewController {
    let VisionObjectRecognitionModel = VisionObjectRecognition.shared
    var selectedImage: UIImage?
    
    var fiftyThousandBillInit = 0
    var tenThousandBillInit = 0
    var fiveThousandBillInit = 0
    var oneThousandBillInit = 0
    
    let priceLabel = UILabel()
    var totalPrice = 0 {
        didSet {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal

            let number = NSNumber(value: Double(totalPrice))
            let formattedNumber = numberFormatter.string(from: number)
            priceLabel.text = "\(formattedNumber ?? "0")원"
        }
    }
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "계산결과"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var billImageView: UIImageView = {
        let imageView = UIImageView()
        
        if let image = selectedImage {
            imageView.image = image
        } else {
            billImageView.image = UIImage(systemName: "questionmark.folder")
        }
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 330),
            imageView.heightAnchor.constraint(equalToConstant: 330)
        ])
        
        return imageView
    }()
    
    private lazy var totalPriceStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .equalSpacing
        
        let totalLabel = UILabel()
        totalLabel.text = "총액"
        totalLabel.font = UIFont(name: "Pretendard-Regular", size: 33)
        
//        priceLabel.text = "\(totalPrice)원"
        priceLabel.font = UIFont(name: "Pretendard-Medium", size: 33)
        
        stackView.addArrangedSubview(totalLabel)
        stackView.addArrangedSubview(priceLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var detailPriceStack: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 18
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
    
    let backgroundRect: UIView = {
        let rect = UIView()
        rect.backgroundColor = .white
        rect.layer.cornerRadius = 5
        rect.layer.masksToBounds = true
        rect.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rect.widthAnchor.constraint(equalToConstant: 360),
            rect.heightAnchor.constraint(equalToConstant: 660)
        ])
        return rect
    }()
    
    let lineImageView: UIImageView = {
        let line = UIImageView()
        line.image = UIImage(named: "lineGray")
        line.translatesAutoresizingMaskIntoConstraints = false
        line.heightAnchor.constraint(equalToConstant: 2).isActive = true
        return line
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor_green")
        
        classifyingCurrencies()
        totalAmount()
        
        view.addSubview(backgroundRect)
        view.addSubview(titleLabel)
        view.addSubview(billImageView)
        view.addSubview(totalPriceStack)
        view.addSubview(lineImageView)
        view.addSubview(detailPriceStack)
        
        
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            backgroundRect.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            backgroundRect.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: backgroundRect.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            billImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            billImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            totalPriceStack.topAnchor.constraint(equalTo: billImageView.bottomAnchor, constant: 15),
            totalPriceStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            totalPriceStack.leadingAnchor.constraint(equalTo: backgroundRect.leadingAnchor, constant: 20),
            totalPriceStack.trailingAnchor.constraint(equalTo: backgroundRect.trailingAnchor, constant: -20),
            
            lineImageView.topAnchor.constraint(equalTo: totalPriceStack.bottomAnchor, constant: 5),
            lineImageView.leadingAnchor.constraint(equalTo: backgroundRect.leadingAnchor, constant: 20),
            lineImageView.trailingAnchor.constraint(equalTo: backgroundRect.trailingAnchor, constant: -20),
            
            detailPriceStack.topAnchor.constraint(equalTo: lineImageView.bottomAnchor, constant: 15),
            detailPriceStack.bottomAnchor.constraint(equalTo: backgroundRect.bottomAnchor, constant: -17),
            detailPriceStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailPriceStack.leadingAnchor.constraint(equalTo: backgroundRect.leadingAnchor, constant: 20),
            detailPriceStack.trailingAnchor.constraint(equalTo: backgroundRect.trailingAnchor, constant: -20)
        
        ])
        
        
        self.title = "MoneyLens"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "darkgreen") ?? .black]
        self.navigationController?.navigationBar.tintColor = UIColor(named: "buttonIconColor_green")
        
        
        
        let saveButton = UIBarButtonItem(title: "저장하기", style: .plain, target: self, action: #selector(saveTapped))
        saveButton.tintColor = UIColor(named: "buttonIconColor_green")
        navigationItem.rightBarButtonItem = saveButton
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        VisionObjectRecognitionModel.dictReset()
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
//        priceLabel.text = "\(totalPrice)원"
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
//                priceLabel.text = "\(totalPrice)원"
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
