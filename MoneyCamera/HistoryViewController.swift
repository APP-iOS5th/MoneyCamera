//
//  HistoryViewController.swift
//  MoneyCamera
//
//  Created by changhyen yun on 6/10/24.
//

//import Foundation
//import UIKit
//
//class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    // 데이터 정해지면 수정 예정
//    private let data:[(itemNmae: String, date: String, image: UIImage?)] = [
//        ("Apple", "2023-06-01", UIImage(systemName: "coloncurrencysign.circle")),
//        ("Banana", "2023-06-02", UIImage(systemName: "coloncurrencysign.circle")),
//        ("Cherry", "2023-06-03", UIImage(systemName: "coloncurrencysign.circle")),
//        ("Date", "2023-06-04", UIImage(systemName: "coloncurrencysign.circle")),
//        ("Elderberry", "2023-06-05", UIImage(systemName: "coloncurrencysign.circle"))
//    ]
//    
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        return tableView
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupTableView()
//    }
//    
//    private func setupTableView() {
//        view.addSubview(tableView)
//        
//        NSLayoutConstraint.activate([
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    // MARK: - UITableViewDataSource
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell
//        let item = data[indexPath.row]
//        guard let unWrappedCell = cell else {
//            return UITableViewCell()
//        }
//
//        unWrappedCell.configure(with: item.itemNmae, date: item.date, image: item.image)
//        return unWrappedCell
//        
//    }
//}
//
//class CustomTableViewCell: UITableViewCell {
//    
//    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let dateLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textColor = .gray
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupViews() {
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(dateLabel)
//        
//        setupViewConstraints()
//    }
//    
//    private func setupViewConstraints() {
//        NSLayoutConstraint.activate([
//            
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
//            
//            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
//            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
//            
//        ])
//    }
//    
//    func configure(with title: String, date: String, image: UIImage?) {
//        titleLabel.text = title
//        dateLabel.text = date
//        contentView.backgroundColor = .clear
//        backgroundView = UIImageView(image: image)
//    }
//}

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var data: [CurrencyRecognitionResult] = []
    
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
        
        loadData()
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
    
    private func loadData() {
        data = DataManager.shared.loadResults()
        print("Loaded data count: \(data.count)") // 디버깅 메시지 추가
        for result in data {
            print("Result: \(result.totalAmount), Date: \(result.date), Image size: \(result.image.size)")
        }
        tableView.reloadData() // 데이터 로드 후 테이블 뷰 갱신
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        let item = data[indexPath.row]
        cell.configure(with: item) { [weak self] in
            self?.deleteItem(at: indexPath)
        }
        return cell
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        let item = data[indexPath.row]
        data.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        DataManager.shared.removeResult(item)
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
    
    private let resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var deleteAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(resultImageView)
        contentView.addSubview(deleteButton)
        
        setupViewConstraints()
    }
    
    private func setupViewConstraints() {
        NSLayoutConstraint.activate([
            resultImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            resultImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            resultImageView.widthAnchor.constraint(equalToConstant: 60),
            resultImageView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.leadingAnchor.constraint(equalTo: resultImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with result: CurrencyRecognitionResult, deleteAction: @escaping () -> Void) {
        titleLabel.text = "\(result.totalAmount)원"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateLabel.text = dateFormatter.string(from: result.date)
        resultImageView.image = result.image
        self.deleteAction = deleteAction
    }
    
    @objc private func deleteButtonTapped() {
        deleteAction?()
    }
}







