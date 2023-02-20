//
//  WmsSheetViewController.swift
//  SerescoMapsUtils
//
//  Created by diegitsen on 19/02/23.
//

import UIKit
import CoreLocation

public class WmsSheetViewController: UIViewController {
    
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(18)
        label.text = "+ Elementos de mi explotación"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let optionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.axis = .vertical
        return stackView
    }()
    let unitedStatesLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(18)
        label.text = "   IGN OrthoimageCoverage"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let populationDensityLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(18)
        label.text = "   IGN Rasterizado"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let recintoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let recintoCheckbox: UIButton = {
        let imageView = UIButton()
        imageView.setImage(UIImage(named: "ic_radio_unselected"), for: .normal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let recintoLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(18)
        label.text = "   Recinto"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dgcView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let dgcCheckbox: UIButton = {
        let imageView = UIButton()
        imageView.setImage(UIImage(named: "ic_radio_unselected"), for: .normal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let dgcLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(18)
        label.text = "   DGC"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let serescoLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(18)
        label.text = "   Cultivos"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let cultivosView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let cultivosCheckbox: UIButton = {
        let imageView = UIButton()
        imageView.setImage(UIImage(named: "ic_radio_unselected"), for: .normal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let cultivosLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(18)
        label.text = "   Cultivos"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var atSixProgressViewHeightAnchor: NSLayoutConstraint?
    var atTwelveProgressViewHeightAnchor: NSLayoutConstraint?
    var atEighteenProgressViewHeightAnchor: NSLayoutConstraint?
    var atTwentyFourProgressViewHeightAnchor: NSLayoutConstraint?
    var humidityStackViewHeightAnchor: NSLayoutConstraint?

    
    // MARK: - Class Properties
    var delegate: WmsOptionDelegate?

    // MARK: - View Life Cycle
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        containerView.layer.cornerRadius = 13
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        setupInteractions()
        setupData()
    }
    
    func setupData() {
        let selectedWmsItems: [WMSItem] = Preferences.shared.getWmsItems()
        selectedWmsItems.forEach { wmsItem in
            setCheckbox(wmsItem: wmsItem)
        }
    }
    
    func setupInteractions() {
        clearView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        
        let recintoGesture = WmsOptionTapGesture(target: self, action: #selector(self.wmsOptionTapped))
        recintoGesture.wmsItem = WMSItem(baseUrl: "xeaga.xunta.gal/geoserver/wms", layer: "Explotacion:Recinto", description: "recinto")
        recintoView.isUserInteractionEnabled = true
        recintoView.addGestureRecognizer(recintoGesture)
        
        let dgcGesture = WmsOptionTapGesture(target: self, action: #selector(self.wmsOptionTapped))
        dgcGesture.wmsItem = WMSItem(baseUrl: "https://xeaga.xunta.gal/geoserver/wms", layer: "Explotacion:DGC", description: "dgc")
        dgcView.isUserInteractionEnabled = true
        dgcView.addGestureRecognizer(dgcGesture)
        
        let cultivosGesture = WmsOptionTapGesture(target: self, action: #selector(self.wmsOptionTapped))
        cultivosGesture.wmsItem = WMSItem(baseUrl: "https://xeaga.xunta.gal/geoserver/wms", layer: "Explotacion:DGC-CULTIVOS", description: "cultivos")
        cultivosView.isUserInteractionEnabled = true
        cultivosView.addGestureRecognizer(cultivosGesture)
    }
    
   
    func setupLayout() {
        view.addSubview(clearView)
        view.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(bottomSheetDecoration)
        containerView.addSubview(optionsStackView)
        
        optionsStackView.addArrangedSubview(recintoView)
        optionsStackView.addArrangedSubview(dgcView)
        optionsStackView.addArrangedSubview(cultivosView)
        
        recintoView.addSubview(recintoCheckbox)
        recintoView.addSubview(recintoLabel)
        
        dgcView.addSubview(dgcCheckbox)
        dgcView.addSubview(dgcLabel)
        
        cultivosView.addSubview(cultivosCheckbox)
        cultivosView.addSubview(cultivosLabel)
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
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            bottomSheetDecoration.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6),
            bottomSheetDecoration.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomSheetDecoration.widthAnchor.constraint(equalToConstant: 38),
            bottomSheetDecoration.heightAnchor.constraint(equalToConstant: 5),
            
            optionsStackView.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 16),
            optionsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            optionsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            optionsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            
            recintoCheckbox.centerYAnchor.constraint(equalTo: recintoView.centerYAnchor),
            recintoCheckbox.leadingAnchor.constraint(equalTo: recintoView.leadingAnchor, constant: 20),
            recintoCheckbox.heightAnchor.constraint(equalToConstant: 30),
            recintoCheckbox.widthAnchor.constraint(equalToConstant: 30),
            recintoLabel.topAnchor.constraint(equalTo: recintoView.topAnchor),
            recintoLabel.leadingAnchor.constraint(equalTo: recintoCheckbox.trailingAnchor, constant: 0),
            recintoLabel.trailingAnchor.constraint(equalTo: recintoView.trailingAnchor, constant: -20),
            recintoLabel.bottomAnchor.constraint(equalTo: recintoView.bottomAnchor),
            
            dgcCheckbox.centerYAnchor.constraint(equalTo: dgcView.centerYAnchor),
            dgcCheckbox.leadingAnchor.constraint(equalTo: dgcView.leadingAnchor, constant: 20),
            dgcCheckbox.heightAnchor.constraint(equalToConstant: 30),
            dgcCheckbox.widthAnchor.constraint(equalToConstant: 30),
            dgcLabel.topAnchor.constraint(equalTo: dgcView.topAnchor),
            dgcLabel.leadingAnchor.constraint(equalTo: dgcCheckbox.trailingAnchor, constant: 0),
            dgcLabel.trailingAnchor.constraint(equalTo: dgcView.trailingAnchor, constant: -20),
            dgcLabel.bottomAnchor.constraint(equalTo: dgcView.bottomAnchor),
            
            cultivosCheckbox.centerYAnchor.constraint(equalTo: cultivosView.centerYAnchor),
            cultivosCheckbox.leadingAnchor.constraint(equalTo: cultivosView.leadingAnchor, constant: 20),
            cultivosCheckbox.heightAnchor.constraint(equalToConstant: 30),
            cultivosCheckbox.widthAnchor.constraint(equalToConstant: 30),
            cultivosLabel.topAnchor.constraint(equalTo: cultivosView.topAnchor),
            cultivosLabel.leadingAnchor.constraint(equalTo: cultivosCheckbox.trailingAnchor, constant: 0),
            cultivosLabel.trailingAnchor.constraint(equalTo: cultivosView.trailingAnchor, constant: -20),
            cultivosLabel.bottomAnchor.constraint(equalTo: cultivosView.bottomAnchor),
            
            unitedStatesLabel.heightAnchor.constraint(equalToConstant: 40),
            populationDensityLabel.heightAnchor.constraint(equalToConstant: 40),
            recintoLabel.heightAnchor.constraint(equalToConstant: 40),
            dgcLabel.heightAnchor.constraint(equalToConstant: 40),
            serescoLabel.heightAnchor.constraint(equalToConstant: 40),
            containerView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    
    // MARK: - Interaction Handling
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func wmsOptionTapped(sender: WmsOptionTapGesture) {
        let wmsItem = sender.wmsItem
        selectCheckBox(wmsItem: wmsItem)
      
        //dismiss(animated: true)
    }
    
    func setCheckboxStatus(checkbox: UIButton, wmsItem: WMSItem) {
        if checkbox.isSelected {
            checkbox.isSelected = false
            checkbox.setImage(UIImage(named: "ic_radio_unselected"), for: .normal)
            delegate?.deselectWmsOption(wmsItem: wmsItem)
        } else {
            checkbox.isSelected = true
            checkbox.setImage(UIImage(named: "ic_radio_selected"), for: .normal)
            delegate?.selectWmsOption(wmsItem: wmsItem)
        }
    }
    
    func selectCheckBox(wmsItem: WMSItem) {
        switch wmsItem.description {
        case "recinto":
            setCheckboxStatus(checkbox: recintoCheckbox, wmsItem: wmsItem)
        case "dgc":
            setCheckboxStatus(checkbox: dgcCheckbox, wmsItem: wmsItem)
        case "cultivos":
            setCheckboxStatus(checkbox: cultivosCheckbox, wmsItem: wmsItem)
        default:
            setCheckboxStatus(checkbox: recintoCheckbox, wmsItem: wmsItem)
        }
    }
    
    func setCheckbox(wmsItem: WMSItem) {
        switch wmsItem.description {
        case "recinto":
            recintoCheckbox.isSelected = true
            recintoCheckbox.setImage(UIImage(named: "ic_radio_selected"), for: .normal)
        case "dgc":
            dgcCheckbox.isSelected = true
            dgcCheckbox.setImage(UIImage(named: "ic_radio_selected"), for: .normal)
        case "cultivos":
            cultivosCheckbox.isSelected = true
            cultivosCheckbox.setImage(UIImage(named: "ic_radio_selected"), for: .normal)
        default:
            recintoCheckbox.isSelected = true
            recintoCheckbox.setImage(UIImage(named: "ic_radio_selected"), for: .normal)
        }
    }
}

class WmsOptionTapGesture: UITapGestureRecognizer {
    var wmsItem: WMSItem = WMSItem(baseUrl: "", layer: "", description: "")
}
