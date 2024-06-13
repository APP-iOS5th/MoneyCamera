//
//  ViewController.swift
//  MoneyCamera
//
//  Created by wonyoul heo on 6/4/24.
//

import UIKit

class RequestImageViewController: UIViewController {
    let VisionObjectRecognitionModel = VisionObjectRecognition.shared
    
    private lazy var mainContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .center
        return stackView
    }()
    
    
    private lazy var moneyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "moneylensIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "MoneyLens"
        titleLabel.font = UIFont(name: "Pretendard-Bold", size: 40)
        titleLabel.textColor = UIColor(named: "buttonIconColor_green")
//        titleLabel.textColor = .gray
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Lion LAB 7"
        subtitleLabel.font = UIFont(name: "Pretendard-Bold", size: 8)
        subtitleLabel.textColor = UIColor(named: "subtitleColor")
//        subtitleLabel.textColor = .lightGray
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return subtitleLabel
    }()
    
    private lazy var buttonContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
        config.image = UIImage(systemName: "camera.fill", withConfiguration: imageConfiguration)
        config.baseBackgroundColor = .white
//        config.baseForegroundColor = .green
        config.baseForegroundColor = UIColor(named: "buttonIconColor_green")
        button.configuration = config
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(cameraTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        return button
    }()
    
    private lazy var albumButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
        config.image = UIImage(systemName: "photo.fill", withConfiguration: imageConfiguration)
        config.baseBackgroundColor = .white
//        config.baseForegroundColor = .green
        config.baseForegroundColor = UIColor(named: "buttonIconColor_green")
        button.configuration = config
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(albumTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        return button
    }()
    
    private lazy var historyButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
        config.image = UIImage(systemName: "list.bullet", withConfiguration: imageConfiguration)
        config.baseBackgroundColor = .white
//        config.baseForegroundColor = .green
        config.baseForegroundColor = UIColor(named: "buttonIconColor_green")
        button.configuration = config
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(historyTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white
        view.backgroundColor = UIColor(named: "backgroundColor_green")
        mainContainer.addArrangedSubview(moneyImageView)
        mainContainer.addArrangedSubview(cameraButton)
        mainContainer.addArrangedSubview(albumButton)
        mainContainer.addArrangedSubview(historyButton)
        
        
        buttonContainer.addArrangedSubview(cameraButton)
        buttonContainer.addArrangedSubview(albumButton)
        buttonContainer.addArrangedSubview(historyButton)
        
        view.addSubview(moneyImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(buttonContainer)
        view.addSubview(mainContainer)
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        moneyImageView.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainContainer.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            mainContainer.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            
            moneyImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            moneyImageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -100),
            moneyImageView.widthAnchor.constraint(equalToConstant: 280),
            moneyImageView.heightAnchor.constraint(equalToConstant: 280),
            
            titleLabel.centerXAnchor.constraint(equalTo: moneyImageView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: moneyImageView.centerYAnchor),
            
            subtitleLabel.trailingAnchor.constraint(equalTo: moneyImageView.trailingAnchor, constant: -33),
            subtitleLabel.bottomAnchor.constraint(equalTo: moneyImageView.bottomAnchor,constant: -30),
            
            buttonContainer.topAnchor.constraint(equalTo: moneyImageView.bottomAnchor, constant: 30),
            buttonContainer.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .inline
        
    }
    
    @objc func cameraTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func albumTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func historyTapped() {
        show(HistoryViewController(), sender: nil)
    }
    
}

// 사진 선택 후
extension RequestImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        guard let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            fatalError("Failed Original Image pick")
        }
        
        guard let coreImage = CIImage(image: userPickedImage) else {
            fatalError("Failed CIImage convert")
        }
        
        VisionObjectRecognitionModel.setupVision()
        VisionObjectRecognitionModel.VisonHandler(image: coreImage)
        
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
