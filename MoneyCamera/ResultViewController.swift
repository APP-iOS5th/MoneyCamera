//
//  ResultViewController.swift
//  MoneyCamera
//
//  Created by wonyoul heo on 6/4/24.
//

import UIKit

class ResultViewController: UIViewController {
    
    var imageView: UIImageView!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Selected Image"
        
        imageView = UIImageView(frame: CGRect.zero)
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        if let image = selectedImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
        }
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        
    }

}
