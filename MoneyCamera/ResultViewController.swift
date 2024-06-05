//
//  ResultViewController.swift
//  MoneyCamera
//
//  Created by wonyoul heo on 6/4/24.
//

import UIKit

class ResultViewController: UIViewController {
    
    
    private lazy var imageView: UIImageView! = {
        let imageView = UIImageView()
        if let image = selectedImage {
            imageView.image = image
        } else {
            fatalError("사진을 불러올 수 없습니다.")
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.title = "Selected Image"
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        
    }

}
