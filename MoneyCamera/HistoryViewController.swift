//
//  HistoryViewController.swift
//  MoneyCamera
//
//  Created by changhyen yun on 6/10/24.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // 데이터 정해지면 수정 예정 
    private let data:[(itemNmae: String, date: String, image: UIImage?)] = [
        ("Apple", "2023-06-01", UIImage(systemName: "coloncurrencysign.circle")),
        ("Banana", "2023-06-02", UIImage(systemName: "coloncurrencysign.circle")),
        ("Cherry", "2023-06-03", UIImage(systemName: "coloncurrencysign.circle")),
        ("Date", "2023-06-04", UIImage(systemName: "coloncurrencysign.circle")),
        ("Elderberry", "2023-06-05", UIImage(systemName: "coloncurrencysign.circle"))
    ]
    
    private lazy var tableView: UITableView = { 
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell
        let item = data[indexPath.row]
        guard let unWrappedCell = cell else {
            return UITableViewCell()
        }

        unWrappedCell.configure(with: item.itemNmae, date: item.date, image: item.image)
        return unWrappedCell
        
    }
}

class CustomTableViewCell: UITableViewCell {
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        
        setupViewConstraints()
    }
    
    private func setupViewConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
        ])
    }
    
    func configure(with title: String, date: String, image: UIImage?) {
        titleLabel.text = title
        dateLabel.text = date
        contentView.backgroundColor = .clear
        backgroundView = UIImageView(image: image)
    }
}
