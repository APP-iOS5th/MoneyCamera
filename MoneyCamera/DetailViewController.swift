//
//  DetailViewController.swift
//  MoneyCamera
//
//  Created by 장예진 on 6/10/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    var result: CurrencyRecognitionResult?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black // 텍스트 색상을 검정색으로 설정
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
        configureView()
    }
    
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(totalAmountLabel)
        view.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            totalAmountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            totalAmountLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: 10)
        ])
    }
    
    private func configureView() {
        guard let result = result else { return }
        imageView.image = result.image
        totalAmountLabel.text = "\(result.totalAmount)원"
        dateLabel.text = formattedDate(result.date)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
