//
//  HistoryViewController.swift
//  MoneyCamera
//
//  Created by changhyen yun on 6/10/24.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var data: [CurrencyRecognitionResult] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationItem.title = "History"
        loadData()
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
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        let item = data[indexPath.row]
        cell.configure(with: "\(item.totalAmount)원", date: formattedDate(item.date), image: item.image)
        return cell
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    // MARK: - UITableViewDelegate
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let detailViewController = DetailViewController()
//        detailViewController.result = data[indexPath.row]
//        navigationController?.pushViewController(detailViewController, animated: true)
//    }
//    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(at: indexPath)
        }
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        let item = data[indexPath.row]
        data.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        DataManager.shared.removeResult(item)
    }
}

class CustomTableViewCell: UITableViewCell {

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 5
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.layer.cornerRadius = 10
//        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11.5)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(resultImageView)
        containerView.addSubview(overlayView)
        overlayView.addSubview(titleLabel)
        overlayView.addSubview(dateLabel)
        setupViewConstraints()
    }

    private func setupViewConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            resultImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            resultImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            resultImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            resultImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            overlayView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            overlayView.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 8),

            dateLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -8),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with title: String, date: String, image: UIImage?) {
        titleLabel.text = title
        dateLabel.text = date
        resultImageView.image = image
    }
}

private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
    return formatter.string(from: date)
}
