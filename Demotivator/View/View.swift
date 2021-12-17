//
//  View.swift
//  Demotivator
//
//  Created by Lucky on 03.08.2021.
//

import UIKit

class CustomView: UIView {
    
    public var handlePhotoLibrary: ((UIButton?) -> Void)?
    public var handlePickerCamera: ((UIButton?) -> Void)?
    public var handleFilters: ((UIButton?) -> Void)?
    public var handleSave: ((UIButton?) -> Void)?
    public var handleSlider: ((UISlider?) -> Void)?
    
    //MARK: - Properties
    let parentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "dots")?.withTintColor(.white)
        iv.layer.cornerRadius = 15
        iv.layer.borderWidth = 0.87
        iv.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Привет, мой друг✌🏼\nТвоё фото будет в рамке сверху ⇧\nА надпись здесь.\n Поехали🚀"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 80, weight: .semibold)
        
        return label
    }()
    
    let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "photos"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 95, left: 95, bottom: 95, right: 95)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapPhotoButton), for: .touchUpInside)
        
        return button
    }()
    
    let filtersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "filters"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 90, left: 90, bottom: 90, right: 90)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapFiltersButton), for: .touchUpInside)
        
        return button
    }()
    
    let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "camera"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 95, left: 95, bottom: 95, right: 95)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCameraButton), for: .touchUpInside)
        
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "save"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 90, left: 90, bottom: 90, right: 90)
        button.tintColor = .black
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        
        return button
    }()
    
    let intensitySlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 10
//     slider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        slider.isContinuous = true
        slider.isHidden = true
        slider.tintColor = UIColor.white
        slider.thumbTintColor = .lightGray
        slider.minimumTrackTintColor = .lightGray
        slider.maximumTrackTintColor = .black
        slider.addTarget(self, action: #selector(didMoveSlider), for: .valueChanged)
        
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = .white
        
        [parentView,photoButton, filtersButton,
         cameraButton, intensitySlider, saveButton]
            .forEach({ self.addSubview($0);
                $0.translatesAutoresizingMaskIntoConstraints = false
            })
    
        [imageView, titleLabel]
            .forEach({ parentView.addSubview($0);
                $0.translatesAutoresizingMaskIntoConstraints = false
            })
    
        setConstraints()
    }
    
    private func setConstraints() {
        setParentImageConstraint()
        setImageViewConstraint()
        setLabelConstraint()
        setPhotoButtonConstraint()
        setFiltersButtonConstraint()
        setCameraButtonConstraint()
        setSliderConstraint()
        setSaveButtonConstraint()
    }
    
    // ParentImageView
    private func setParentImageConstraint() {
        NSLayoutConstraint.activate([
            parentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            parentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            parentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            parentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -200)
        ])
    }
    
    // ImageView
    private func setImageViewConstraint() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 25),
            imageView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -25),
            imageView.heightAnchor.constraint(equalTo: parentView.heightAnchor, multiplier: 0.65),
        ])
    }
    
    // PhotoButton
    private func setPhotoButtonConstraint() {
        NSLayoutConstraint.activate([
            photoButton.widthAnchor.constraint(equalToConstant: 90),
            photoButton.heightAnchor.constraint(equalToConstant: 90),
            photoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            photoButton.trailingAnchor.constraint(equalTo: filtersButton.leadingAnchor, constant: -5),
            photoButton.topAnchor.constraint(equalTo: parentView.bottomAnchor, constant: 20)
        ])
    }
    
    // CameraButton
    private func setCameraButtonConstraint() {
        NSLayoutConstraint.activate([
            cameraButton.widthAnchor.constraint(equalToConstant: 90),
            cameraButton.heightAnchor.constraint(equalToConstant: 90),
            cameraButton.leadingAnchor.constraint(equalTo: filtersButton.trailingAnchor, constant: 12),
            cameraButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -5),
            cameraButton.topAnchor.constraint(equalTo: parentView.bottomAnchor, constant: 20)
        ])
    }
    
    // FilterButton
    private func setFiltersButtonConstraint() {
        NSLayoutConstraint.activate([
            filtersButton.widthAnchor.constraint(equalToConstant: 90),
            filtersButton.heightAnchor.constraint(equalToConstant: 90),
            filtersButton.trailingAnchor.constraint(equalTo: cameraButton.leadingAnchor, constant: -5),
            filtersButton.topAnchor.constraint(equalTo: parentView.bottomAnchor, constant: 20)
        ])
    }
    
    // Label
    private func setLabelConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 145),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -30)
        ])
    }
    
    // Slider
    private func setSliderConstraint() {
        NSLayoutConstraint.activate([
            intensitySlider.widthAnchor.constraint(equalToConstant: 150),
            intensitySlider.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 21),
            intensitySlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35),
            intensitySlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            intensitySlider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }
    
    // SaveButton
    private func setSaveButtonConstraint() {
            NSLayoutConstraint.activate([
                saveButton.topAnchor.constraint(equalTo: parentView.bottomAnchor, constant: 20),
               saveButton.widthAnchor.constraint(equalToConstant: 90),
               saveButton.heightAnchor.constraint(equalToConstant: 90),
                saveButton.leadingAnchor.constraint(equalTo: cameraButton.trailingAnchor, constant: 15)
        ])
    }
    
    //MARK: - Actions
    @objc
    private func didTapPhotoButton(_ sender: UIButton?) {
        handlePhotoLibrary?(sender)
    }
    
    @objc
    private func didTapCameraButton(_ sender: UIButton?) {
        handlePickerCamera?(sender)
    }
    
    @objc
    private func didMoveSlider(_ sender: UISlider) {
        handleSlider?(sender)
    }
    
    @objc
    private func didTapFiltersButton(_ sender: UIButton) {
        handleFilters?(sender)
    }
    
    @objc
    private func didTapSaveButton(_ sender: UIButton) {
        handleSave?(sender)
    }
}
