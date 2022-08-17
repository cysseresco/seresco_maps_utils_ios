//
//  ColorSheetViewController.swift
//  TestLibs
//
//  Created by Diego Salcedo on 13/08/22.
//

import UIKit

public protocol ColorSheetDelegate {
    func updateColor(color: UIColor)
}

/// Muetra las opciones para configurar de acuerdo  a los colores
public class ColorSheetViewController: UIViewController {
    
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
        label.text = "Cambiar color"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let redView: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let yellowView: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.yellow
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let blueView: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let skyBlueView: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.skyBlue
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let greenView: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.green
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let brownView: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.brown
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let colorsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.axis = .horizontal
        return stackView
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setAttributedTitle(
            NSAttributedString(string: "Aceptar", attributes: [
               // NSAttributedString.Key.font: UIFont(name: "SFProText-Semibold", size: 16) as Any,
                NSAttributedString.Key.foregroundColor: UIColor.black,
            ]),
            for: .normal)
        button.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor.mainColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    // MARK: - Class Properties
    public var delegate: ColorSheetDelegate?

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
    //todo::sheet base
    func setupInteractions() {
        clearView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        
        let redTapGesture = ColorTapGesture(target: self, action: #selector(self.colorTapped))
        redTapGesture.colorType = .colorRed
        redView.addGestureRecognizer(redTapGesture)
        
        let yellowTapGesture = ColorTapGesture(target: self, action: #selector(self.colorTapped))
        yellowTapGesture.colorType = .colorYellow
        yellowView.addGestureRecognizer(yellowTapGesture)
        
        let blueTapGesture = ColorTapGesture(target: self, action: #selector(self.colorTapped))
        blueTapGesture.colorType = .colorBlue
        blueView.addGestureRecognizer(blueTapGesture)
        
        let skyBlueTapGesture = ColorTapGesture(target: self, action: #selector(self.colorTapped))
        skyBlueTapGesture.colorType = .colorSkyBlue
        skyBlueView.addGestureRecognizer(skyBlueTapGesture)
        
        let greenTapGesture = ColorTapGesture(target: self, action: #selector(self.colorTapped))
        greenTapGesture.colorType = .colorGreen
        greenView.addGestureRecognizer(greenTapGesture)
        
        let brownTapGesture = ColorTapGesture(target: self, action: #selector(self.colorTapped))
        brownTapGesture.colorType = .colorBrown
        brownView.addGestureRecognizer(brownTapGesture)
    }
    
    func setupView() {
        
        // Tap Gesture
        
    }
    
    func setupLayout() {
        view.addSubview(clearView)
        view.addSubview(containerView)
        containerView.addSubview(bottomSheetDecoration)
        containerView.addSubview(titleLabel)
        containerView.addSubview(colorsStackView)
        containerView.addSubview(acceptButton)
        
        colorsStackView.addArrangedSubview(redView)
        colorsStackView.addArrangedSubview(yellowView)
        colorsStackView.addArrangedSubview(blueView)
        colorsStackView.addArrangedSubview(skyBlueView)
        colorsStackView.addArrangedSubview(greenView)
        colorsStackView.addArrangedSubview(brownView)
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
            
            colorsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            colorsStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            redView.widthAnchor.constraint(equalToConstant: 30),
            redView.heightAnchor.constraint(equalToConstant: 30),
            yellowView.widthAnchor.constraint(equalToConstant: 30),
            yellowView.heightAnchor.constraint(equalToConstant: 30),
            blueView.widthAnchor.constraint(equalToConstant: 30),
            blueView.heightAnchor.constraint(equalToConstant: 30),
            
            acceptButton.topAnchor.constraint(equalTo: colorsStackView.bottomAnchor, constant: 20),
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
    @objc func colorTapped(sender: ColorTapGesture) {
        let type = sender.colorType
        delegate?.updateColor(color: type.color)
    }
    
    // MARK: - Class Methods

}

class ColorTapGesture: UITapGestureRecognizer {
    var colorType: ColorType = .colorRed
}
