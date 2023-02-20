//
//  MarkerInfoBottomSheet.swift
//  SerescoMapsUtils
//
//  Created by Diego Salcedo on 13/08/22.
//

import UIKit
//import Kingfisher

public class MarkerSheetViewController: UIViewController {

    // MARK: - UI Components
    let clearView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let containerView: UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomSheetDecoration: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2.5
        view.backgroundColor = UIColor.bottomSheetDecorationColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //todo::custom labels
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.text = "Nombre"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let placeImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 6
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setAttributedTitle(
            NSAttributedString(string: "Aceptar", attributes: [
               // NSAttributedString.Key.font: UIFont(name: "SFProText-Semibold", size: 16) as Any,
                NSAttributedString.Key.foregroundColor: UIColor.black,
            ]),
            for: .normal)
        button.backgroundColor = UIColor.mainColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    // MARK: - Class Properties
    public var markerProperties: MarkerProperties?

    // MARK: - View Life Cycle
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        acceptButton.layer.cornerRadius = acceptButton.frame.height / 2
        containerView.layer.cornerRadius = 13
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        setupView()
        setupInteractions()
    }
    
    func setupInteractions() {
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    
    func setupView() {
        
        // Tap Gesture
        clearView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        
        // KingFisher
//        let url = URL(string: markerProperties?.snippet ?? "")
//        if let urlData = url {
//            let resource = ImageResource(downloadURL: urlData, cacheKey: markerProperties?.name ?? "")
//            placeImage.kf.indicatorType = .activity
//            placeImage.kf.setImage(with: resource)
//        }
        
        //Title
        titleLabel.text = markerProperties?.name ?? ""
    }
    
    func setupLayout() {
        view.addSubview(clearView)
        view.addSubview(containerView)
        containerView.addSubview(bottomSheetDecoration)
        containerView.addSubview(titleLabel)
        containerView.addSubview(placeImage)
        containerView.addSubview(acceptButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            clearView.topAnchor.constraint(equalTo: view.topAnchor),
            clearView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            clearView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            clearView.bottomAnchor.constraint(equalTo: containerView.topAnchor),
            
            containerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
            
            bottomSheetDecoration.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6),
            bottomSheetDecoration.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomSheetDecoration.widthAnchor.constraint(equalToConstant: 38),
            bottomSheetDecoration.heightAnchor.constraint(equalToConstant: 5),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            placeImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            placeImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            placeImage.widthAnchor.constraint(equalToConstant: 200),
            placeImage.heightAnchor.constraint(equalToConstant: 200),
            
            acceptButton.topAnchor.constraint(equalTo: placeImage.bottomAnchor, constant: 20),
            acceptButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            acceptButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
            acceptButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -35),
        ])
    }
    
    
    // MARK: - Interaction Handling
    @objc func acceptButtonTapped() {
        dismiss(animated: true)
    }
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Class Methods

}
