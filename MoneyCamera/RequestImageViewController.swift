//
//  ViewController.swift
//  MoneyCamera
//
//  Created by wonyoul heo on 6/4/24.
//

import UIKit
import CoreML
import Vision

class RequestImageViewController: UIViewController {
    
    private lazy var mainContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var moneyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "wonsign.arrow.circlepath")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        config.title = "촬영하기"
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        button.configuration = config
        button.addTarget(self, action: #selector(cameraTapped), for: .touchUpInside)
        return button
    }()
    
    var imagePicker: UIImagePickerController{
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        return picker
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        mainContainer.addArrangedSubview(moneyImageView)
        mainContainer.addArrangedSubview(cameraButton)
        
        view.addSubview(mainContainer)
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        moneyImageView.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainContainer.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            mainContainer.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            
            moneyImageView.widthAnchor.constraint(equalToConstant: 150),
            moneyImageView.heightAnchor.constraint(equalToConstant: 150),
            
            cameraButton.widthAnchor.constraint(equalToConstant: 100),
            cameraButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        navigationItem.title = "MoneyCamera"
        navigationItem.largeTitleDisplayMode = .inline

    }
    
    @objc func cameraTapped() {
        present(imagePicker, animated: true)
    }
}

// 사진 선택 후
extension RequestImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        guard let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            fatalError("Failed Original Image pick")
        }
        
        picker.dismiss(animated: true){
            
            let resultViewController = ResultViewController()
            resultViewController.selectedImage = userPickedImage
            self.navigationController?.pushViewController(resultViewController, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}


