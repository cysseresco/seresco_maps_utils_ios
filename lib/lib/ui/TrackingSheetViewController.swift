//
//  TrackingSheetViewController.swift
//  SerescoMapsUtils
//
//  Created by Diego Salcedo on 18/08/22.
//  Copyright © 2022 Seresco. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import CodableGeoJSON

public protocol TrackingSheetDelegate {
    func sendCoordinates(coordinates: [[Double]])
}

public class TrackingSheetViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
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
    let topConfigureView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let trackingSwitch: UISwitch = {
        let trackingSwitch = UISwitch()
        trackingSwitch.tintColor = .mainColor
        trackingSwitch.onTintColor = .mainColor
        trackingSwitch.translatesAutoresizingMaskIntoConstraints = false
        return trackingSwitch
    }()
    let trackingTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Tracking manual"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let cleanButton: UIButton = {
        let button = UIButton()
        button.setTitle("Limpiar", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let trackingStatusStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 14
        stackView.axis = .vertical
        return stackView
    }()
    let automaticTrackingButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.isHidden = true
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.axis = .horizontal
        return stackView
    }()
    let fiveSecondsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("5s", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let tenSecondsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 10
        button.setTitle("10s", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let thirtySecondsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("30s", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let sixtySecondsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("60s", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let trackingStatusLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.text = "Actualizar coordenadas"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let trackButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.mainColor
        button.layer.cornerRadius = 24
        button.setImage(UIImage(named: "ic_tracking"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let infoTrackingView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let latitudeLabel: UILabel = {
        let label = UILabel()
        label.text = "Latitude: -"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let longitudeLabel: UILabel = {
        let label = UILabel()
        label.text = "Longitude: -"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let coordinatePointsQuantityLabel: UILabel = {
        let label = UILabel()
        label.text = "0 Puntos Obtenidos"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    public var delegate: TrackingSheetDelegate?
    var currentTrackingType: TrackingType = .manual
    var currentAutomaticTrackingType: AutomaticTrackingType = .fiveSeconds
    var locationManager = CLLocationManager()
    var coordinatesObtained = [[Double]]()
    let preferences = Preferences.shared
    var countdownTimer = Timer()
    var isShowingToast = false

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
        locationManager.delegate = self
        
        clearView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        
        trackingSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        
        cleanButton.addTarget(self, action: #selector(clearCoordinates), for: .touchUpInside)

        let fiveSecondsTapGesture = AutomaticTrackingTypeTapGesture(target: self, action: #selector(self.optionTrackingTapped))
        fiveSecondsTapGesture.automaticTrackingType = .fiveSeconds
        fiveSecondsButton.addGestureRecognizer(fiveSecondsTapGesture)
        
        let tenSecondsTapGesture = AutomaticTrackingTypeTapGesture(target: self, action: #selector(self.optionTrackingTapped))
        tenSecondsTapGesture.automaticTrackingType = .tenSeconds
        tenSecondsButton.addGestureRecognizer(tenSecondsTapGesture)
        
        let thirtySecondsTapGesture = AutomaticTrackingTypeTapGesture(target: self, action: #selector(self.optionTrackingTapped))
        thirtySecondsTapGesture.automaticTrackingType = .thirtySeconds
        thirtySecondsButton.addGestureRecognizer(thirtySecondsTapGesture)
        
        let sixtySecondsTapGesture = AutomaticTrackingTypeTapGesture(target: self, action: #selector(self.optionTrackingTapped))
        sixtySecondsTapGesture.automaticTrackingType = .sixtySeconds
        sixtySecondsButton.addGestureRecognizer(sixtySecondsTapGesture)
        
        trackButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.startTrackingTapped)))
    }
    
    func setupView() {
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        let coordinates = preferences.getCoordinates()
        coordinatesObtained = coordinates
        setCoordinatesInfo()
    }
    
    func initTimer() {
        countdownTimer.invalidate()
        countdownTimer = Timer.scheduledTimer(timeInterval: currentAutomaticTrackingType.time, target: self, selector: #selector(processAutomaticTracking), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        countdownTimer.invalidate()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else {
            return
        }
        startTracking(coordinate: coordinate)
    }
    
    private func startTracking(coordinate: CLLocationCoordinate2D) {
        coordinatesObtained.append([coordinate.longitude, coordinate.latitude])
        setCoordinatesInfo()
        preferences.saveCoordinates(coords: coordinatesObtained)
        delegate?.sendCoordinates(coordinates: coordinatesObtained)
        locationManager.stopUpdatingLocation()
    }
    
    private func startAutomaticTracking() {
        if trackingStatusLabel.text == "Inactivo" {
            trackingStatusLabel.text = "Detener"
            trackButton.setImage(UIImage(named: "ic_stop"), for: .normal)
            initTimer()
        } else {
            trackingStatusLabel.text = "Inactivo"
            trackButton.setImage(UIImage(named: "ic_tracking"), for: .normal)
            stopTimer()
        }
    }
    
    private func startManualTracking() {
        if countdownTimer.isValid {
            countdownTimer.invalidate()
        }
        locationManager.startUpdatingLocation()
    }
    
    private func setCoordinatesInfo() {
        if coordinatesObtained.first?.isEmpty == true && coordinatesObtained.count == 1 {
            latitudeLabel.text = "Latitude: -"
            longitudeLabel.text = "Longitude: -"
            coordinatePointsQuantityLabel.text = "0 Puntos Obtenidos"
        } else if coordinatesObtained.isEmpty {
            latitudeLabel.text = "Latitude: -"
            longitudeLabel.text = "Longitude: -"
            coordinatePointsQuantityLabel.text = "0 Puntos Obtenidos"
        } else {
            latitudeLabel.text = "Latitude: \(coordinatesObtained.last?.first ?? 0.0)"
            longitudeLabel.text = "Longitude: \(coordinatesObtained.last?.last ?? 0.0)"
            if coordinatesObtained.count == 1 {
                coordinatePointsQuantityLabel.text = "1 Punto Obtenido"
            } else {
                coordinatePointsQuantityLabel.text = "\(coordinatesObtained.count) Puntos Obtenidos"
            }
        }
    }
    
    func setupLayout() {
        view.addSubview(clearView)
        view.addSubview(containerView)
        containerView.addSubview(bottomSheetDecoration)
        containerView.addSubview(topConfigureView)
        containerView.addSubview(trackingStatusStackView)
        containerView.addSubview(trackButton)
        containerView.addSubview(infoTrackingView)
        containerView.addSubview(acceptButton)
        
        automaticTrackingButtonsStackView.addArrangedSubview(fiveSecondsButton)
        automaticTrackingButtonsStackView.addArrangedSubview(tenSecondsButton)
        automaticTrackingButtonsStackView.addArrangedSubview(thirtySecondsButton)
        automaticTrackingButtonsStackView.addArrangedSubview(sixtySecondsButton)

        trackingStatusStackView.addArrangedSubview(automaticTrackingButtonsStackView)
        trackingStatusStackView.addArrangedSubview(trackingStatusLabel)
        
        topConfigureView.addSubview(trackingSwitch)
        topConfigureView.addSubview(trackingTypeLabel)
        topConfigureView.addSubview(cleanButton)
        
        infoTrackingView.addSubview(latitudeLabel)
        infoTrackingView.addSubview(longitudeLabel)
        infoTrackingView.addSubview(coordinatePointsQuantityLabel)
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
            
            topConfigureView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            topConfigureView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            topConfigureView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            trackingSwitch.topAnchor.constraint(equalTo: topConfigureView.topAnchor),
            trackingSwitch.leadingAnchor.constraint(equalTo: topConfigureView.leadingAnchor),
            trackingSwitch.centerYAnchor.constraint(equalTo: topConfigureView.centerYAnchor),
            trackingTypeLabel.topAnchor.constraint(equalTo: topConfigureView.topAnchor),
            trackingTypeLabel.leadingAnchor.constraint(equalTo: trackingSwitch.trailingAnchor, constant: 20),
            trackingTypeLabel.centerYAnchor.constraint(equalTo: topConfigureView.centerYAnchor),
            cleanButton.topAnchor.constraint(equalTo: topConfigureView.topAnchor),
            cleanButton.trailingAnchor.constraint(equalTo: topConfigureView.trailingAnchor),
            cleanButton.centerYAnchor.constraint(equalTo: topConfigureView.centerYAnchor),
            
            trackingStatusStackView.topAnchor.constraint(equalTo: topConfigureView.bottomAnchor, constant: 20),
            trackingStatusStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            fiveSecondsButton.widthAnchor.constraint(equalToConstant: 48),
            fiveSecondsButton.heightAnchor.constraint(equalToConstant: 48),
            
            trackButton.topAnchor.constraint(equalTo: trackingStatusLabel.bottomAnchor, constant: 20),
            trackButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            trackButton.widthAnchor.constraint(equalToConstant: 48),
            trackButton.heightAnchor.constraint(equalToConstant: 48),
            
            infoTrackingView.topAnchor.constraint(equalTo: trackButton.bottomAnchor, constant: 20),
            infoTrackingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            infoTrackingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            
            latitudeLabel.topAnchor.constraint(equalTo: infoTrackingView.topAnchor, constant: 10),
            latitudeLabel.centerXAnchor.constraint(equalTo: infoTrackingView.centerXAnchor),
            longitudeLabel.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: 8),
            longitudeLabel.centerXAnchor.constraint(equalTo: infoTrackingView.centerXAnchor),
            coordinatePointsQuantityLabel.topAnchor.constraint(equalTo: longitudeLabel.bottomAnchor, constant: 8),
            coordinatePointsQuantityLabel.centerXAnchor.constraint(equalTo: infoTrackingView.centerXAnchor),
            coordinatePointsQuantityLabel.bottomAnchor.constraint(equalTo: infoTrackingView.bottomAnchor, constant: -10),
            
            acceptButton.topAnchor.constraint(equalTo: infoTrackingView.bottomAnchor, constant: 20),
            acceptButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            acceptButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
            acceptButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -35),
        ])
    }
    
    
    // MARK: - Interaction Handling
    @objc func acceptButtonTapped() {
        if countdownTimer.isValid {
          //  showToast(message: "Para cerrar la vista primero de debe detener el trackeo automático")
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    @objc func dismissView() {
        if countdownTimer.isValid {
          //  showToast(message: "Para cerrar la vista primero de debe detener el trackeo automático")
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    @objc func switchChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
            currentTrackingType = .automatic
            automaticTrackingButtonsStackView.isHidden = false
            trackingTypeLabel.text = "Tracking automático"
            trackingStatusLabel.text = "Inactivo"
        } else {
            currentTrackingType = .manual
            automaticTrackingButtonsStackView.isHidden = true
            trackingTypeLabel.text = "Tracking manual"
            trackingStatusLabel.text = "Actualizar coordenadas"
        }
    }
    @objc func optionTrackingTapped(sender: AutomaticTrackingTypeTapGesture) {
        switch sender.automaticTrackingType {
        case .fiveSeconds:
            fiveSecondsButton.layer.borderWidth = 1
            tenSecondsButton.layer.borderWidth = 0
            thirtySecondsButton.layer.borderWidth = 0
            sixtySecondsButton.layer.borderWidth = 0
            currentAutomaticTrackingType = .fiveSeconds
        case .tenSeconds:
            fiveSecondsButton.layer.borderWidth = 0
            tenSecondsButton.layer.borderWidth = 1
            thirtySecondsButton.layer.borderWidth = 0
            sixtySecondsButton.layer.borderWidth = 0
            currentAutomaticTrackingType = .tenSeconds
        case .thirtySeconds:
            fiveSecondsButton.layer.borderWidth = 0
            tenSecondsButton.layer.borderWidth = 0
            thirtySecondsButton.layer.borderWidth = 1
            sixtySecondsButton.layer.borderWidth = 0
            currentAutomaticTrackingType = .thirtySeconds
        case .sixtySeconds:
            fiveSecondsButton.layer.borderWidth = 0
            tenSecondsButton.layer.borderWidth = 0
            thirtySecondsButton.layer.borderWidth = 0
            sixtySecondsButton.layer.borderWidth = 1
            currentAutomaticTrackingType = .sixtySeconds
        }
    }
    @objc func startTrackingTapped() {
        switch currentTrackingType {
        case .manual:
            startManualTracking()
        case .automatic:
            startAutomaticTracking()
        }
    }
    @objc func clearCoordinates() {
        coordinatesObtained = []
        preferences.saveCoordinates(coords: [])
        setCoordinatesInfo()
        delegate?.sendCoordinates(coordinates: coordinatesObtained)
    }
    @objc func processAutomaticTracking() {
        locationManager.startUpdatingLocation()
    }
}

class AutomaticTrackingTypeTapGesture: UITapGestureRecognizer {
    var automaticTrackingType: AutomaticTrackingType = .fiveSeconds
}
