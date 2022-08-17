//
//  KmlSheetViewController.swift
//  TestLibs
//
//  Created by Diego Salcedo on 14/08/22.
//

import UIKit

public protocol KmlSheetDelegate {
    func updateStrokeColor(color: UIColor)
    func updateFillColor(color: UIColor)
    func updateOpacity(alpha: Float)
}

/// Muestra las configuraciones con respecto al KML
public class KmlSheetViewController: UIViewController {
    
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
        label.font = label.font.withSize(18)
        label.text = "Configurar KML"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
        label.text = "Actualizar color de borde:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Options Components
    let strokeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.mainColor
        button.layer.cornerRadius = 24
        button.setImage(UIImage(named: "ic_stroke"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let fillButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 24
        button.setImage(UIImage(named: "ic_fill"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let opacityButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 24
        button.setImage(UIImage(named: "ic_opacity"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let optionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.axis = .horizontal
        return stackView
    }()
    // MARK: - Silder Component
    let opacitySlider: UISlider = {
        let slider = UISlider()
        slider.tintColor = UIColor.mainColor
        slider.value = 1.0
        slider.isHidden = true
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    // MARK: - Colors Component
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
        stackView.isHidden = false
        stackView.axis = .horizontal
        return stackView
    }()
    let componentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 14
        stackView.axis = .vertical
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
        button.backgroundColor = UIColor.mainColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    // MARK: - Class Properties
    public var delegate: KmlSheetDelegate?
    var currentKmlType: KmlOptionType = .updateStrokeColor

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
        
        opacitySlider.addTarget(self, action: #selector(opacitySliderDidValueChange), for: .valueChanged)
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        
        // Colors
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
        
        // Options
        let updateStrokeTapGesture = KmlTypeTapGesture(target: self, action: #selector(self.optionTapped))
        updateStrokeTapGesture.kmlType = .updateStrokeColor
        strokeButton.addGestureRecognizer(updateStrokeTapGesture)
        
        let updateFillTapGesture = KmlTypeTapGesture(target: self, action: #selector(self.optionTapped))
        updateFillTapGesture.kmlType = .updateFillColor
        fillButton.addGestureRecognizer(updateFillTapGesture)
        
        let updateOpacityTapGesture = KmlTypeTapGesture(target: self, action: #selector(self.optionTapped))
        updateOpacityTapGesture.kmlType = .updateOpacity
        opacityButton.addGestureRecognizer(updateOpacityTapGesture)
    }
    
    func setupView() {
        
        // Tap Gesture
        
    }
    
    func setupLayout() {
        view.addSubview(clearView)
        view.addSubview(containerView)
        containerView.addSubview(bottomSheetDecoration)
        containerView.addSubview(titleLabel)
        containerView.addSubview(optionsStackView)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(componentsStackView)
        containerView.addSubview(acceptButton)
        
        optionsStackView.addArrangedSubview(strokeButton)
        optionsStackView.addArrangedSubview(fillButton)
        optionsStackView.addArrangedSubview(opacityButton)
        
        colorsStackView.addArrangedSubview(redView)
        colorsStackView.addArrangedSubview(yellowView)
        colorsStackView.addArrangedSubview(blueView)
        colorsStackView.addArrangedSubview(skyBlueView)
        colorsStackView.addArrangedSubview(greenView)
        colorsStackView.addArrangedSubview(brownView)
        
        componentsStackView.addArrangedSubview(colorsStackView)
        componentsStackView.addArrangedSubview(opacitySlider)
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
            
            optionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            optionsStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            strokeButton.widthAnchor.constraint(equalToConstant: 48),
            strokeButton.heightAnchor.constraint(equalToConstant: 48),
            
            subtitleLabel.topAnchor.constraint(equalTo: optionsStackView.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            
            componentsStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            componentsStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            opacitySlider.heightAnchor.constraint(equalToConstant: 30),
            colorsStackView.heightAnchor.constraint(equalToConstant: 30),
            redView.widthAnchor.constraint(equalToConstant: 30),
            redView.heightAnchor.constraint(equalToConstant: 30),
            
            acceptButton.topAnchor.constraint(equalTo: componentsStackView.bottomAnchor, constant: 20),
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
    @objc func opacitySliderDidValueChange(sender: UISlider) {
        delegate?.updateOpacity(alpha: sender.value)
    }
    @objc func optionTapped(sender: KmlTypeTapGesture) {
        switch sender.kmlType {
        case .updateStrokeColor:
            self.opacitySlider.isHidden = true
            self.colorsStackView.isHidden = false
            self.subtitleLabel.text = "Actualizar color de borde:"
            self.opacityButton.backgroundColor = .clear
            self.fillButton.backgroundColor = .clear
            self.strokeButton.backgroundColor = .mainColor
            self.currentKmlType = .updateStrokeColor
        case .updateFillColor:
            self.opacitySlider.isHidden = true
            self.colorsStackView.isHidden = false
            self.subtitleLabel.text = "Actualizar color de fondo:"
            self.opacityButton.backgroundColor = .clear
            self.fillButton.backgroundColor = .mainColor
            self.strokeButton.backgroundColor = .clear
            self.currentKmlType = .updateFillColor
        case .updateOpacity:
            self.opacitySlider.isHidden = false
            self.colorsStackView.isHidden = true
            self.subtitleLabel.text = "Actualizar transparencia/opacidad:"
            self.opacityButton.backgroundColor = .mainColor
            self.fillButton.backgroundColor = .clear
            self.strokeButton.backgroundColor = .clear
            self.currentKmlType = .updateOpacity
        }
    }
    @objc func colorTapped(sender: ColorTapGesture) {
        let type = sender.colorType
        if self.currentKmlType == .updateStrokeColor {
            delegate?.updateStrokeColor(color: type.color)
        } else {
            delegate?.updateFillColor(color: type.color)
        }
    }
    
    // MARK: - Class Methods

}

class KmlTypeTapGesture: UITapGestureRecognizer {
    var kmlType: KmlOptionType = .updateStrokeColor
}
