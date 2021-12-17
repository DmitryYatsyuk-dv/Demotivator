//
//  ViewController.swift
//  Demotivator
//
//  Created by Lucky on 03.08.2021.
//

import UIKit
import PhotosUI
import CoreImage

class MainViewController: UIViewController {
    
    //MARK: - Properties
    var mainView = CustomView()
    var context: CIContext!
    var currentFilter: CIFilter!
    var currentImage: UIImage!
    
    private lazy var titleLabel = mainView.titleLabel
    private let picker = UIImagePickerController()
    private var filter = PHPickerFilter.any(of: [.images])
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPickerControllers()
        movesTheSlider()
        editFiltersChange()
        saveCreatedImage()
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    //MARK: - Actions
    private func saveCreatedImage() {
        mainView.handleSave = { [weak self] _ in
            
            let renderer = UIGraphicsImageRenderer(bounds: (self?.mainView.parentView.bounds)!)
            let image = renderer.image { rendererContext in
                self?.mainView.parentView.layer.render(in: rendererContext.cgContext)
            }
            
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           #selector(self?.image(_:didFinishSavingWithError:contextInfo:)),
                                           nil)
        }
    }
    
    private func editFiltersChange() {
        mainView.handleFilters = { [weak self] sender in
            guard let sender = sender else { return }
            self?.changeFilters(sender: sender)
        }
    }
    
    private func movesTheSlider() {
        mainView.handleSlider = { [weak self] _ in
            self?.applyProcessing()
        }
    }
    
    private func showPhotoLibrary() {
        mainView.handlePhotoLibrary = { [weak self] _ in
            self?.presentPickerController(filter: self?.filter)
        }
    }
    
    private func showPickerCamera() {
        mainView.handlePickerCamera = { [weak self] _ in
            self?.presentPickerCamera(picker: self?.picker)
        }
    }
    
    //MARK: - Helpers
    private func setPickerControllers() {
        showPhotoLibrary()
        showPickerCamera()
    }
    
    @objc
    private func image(_ image: UIImage, didFinishSavingWithError error: Error?,
                       contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save ERROR", message: error.localizedDescription,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
        } else {
            let ac = UIAlertController(title: "Сохранено", message: "Ваш демотиватор был успешно сохранен в фото-библиотеку", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }
    
    private func changeFilters(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Choose filter",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(
                                    title: "CIGaussianBlur",
                                    style: .default,
                                    handler: setFilter))
        alertController.addAction(UIAlertAction(
                                    title: "CISepiaTone",
                                    style: .default,
                                    handler: setFilter))
        alertController.addAction(UIAlertAction(
                                    title: "CIUnsharpMask",
                                    style: .default,
                                    handler: setFilter))
        alertController.addAction(UIAlertAction(
                                    title: "CIVignette",
                                    style: .default,
                                    handler: setFilter))
        alertController.addAction(UIAlertAction(
                                    title: "CIPixellate",
                                    style: .default,
                                    handler: setFilter))
        alertController.addAction(UIAlertAction(
                                    title: "CITwirlDistortion",
                                    style: .default,
                                    handler: setFilter))
        alertController.addAction(UIAlertAction(
                                    title: "Cancel",
                                    style: .cancel))
        
        alertController.view.tintColor = .black
        mainView.intensitySlider.isHidden = false
        present(alertController, animated: true)
    }
    
    func setFilter(action: UIAlertAction) {
        
        guard let actionTitle = action.title else { return }
        guard let image  = mainView.imageView.image else { return }
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: image)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    // Apply Processing set filters
    private func applyProcessing() {
        /*
         Не все фильтры имеют ключи интесивности,
         поэтому сделаем проверку на наличие нескольких ключей для различных фильтров.
         Исчерпывающая информация по фильтрам и их свойствам ->
         https://cifilter.io/
         https://github.com/noahsark769/cifilter.io
         */
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(mainView.intensitySlider.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(mainView.intensitySlider.value * 50, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(mainView.intensitySlider.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(
                                    x: mainView.imageView.center.x,
                                    y: mainView.imageView.center.y),
                                   forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let finalImage = UIImage(cgImage: cgImage)
            mainView.imageView.image = finalImage
        }
    }
    
    // Camera
    private func presentPickerCamera(picker: UIImagePickerController?) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let alertController = UIAlertController(title: nil,
                                                    message: "Sorry, your device has not a camera.",
                                                    preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "Oups..",
                                         style: .default,
                                         handler: { (alert: UIAlertAction!) in
                                         })
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            guard let picker = picker else { return }
            picker.delegate = self
            picker.sourceType = .camera
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
    }
    
    // PhotoGallery
    private func presentPickerController(filter: PHPickerFilter?) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = filter
        
        configuration.preferredAssetRepresentationMode = .current
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    // AlertController
    private func setAlertController() {
        let alertController = UIAlertController(title: "Ваша цитата",
                                                message: "•Не забудь добавить фильтр к фото\n•Задать интенсивность\n(с помощью бегунка в нижней части экрана)\nУдачи",
                                                preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction) in
            let textField = (alertController.textFields![0]) as UITextField
            if textField.text != "" {
                self.titleLabel.text = textField.text
            } else {
                self.titleLabel.text = " "
            }
        })
        
        alertController.addTextField { textField in
            textField.placeholder = "Введите своё описание."
        }
        
        alertController.addAction(doneAction)
        alertController.addAction(UIAlertAction(title: "Отменить", style: .default))
        
        self.present(alertController, animated: true)
    }
}

//MARK: - PHPickerViewControllerDelegate
extension MainViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        mainView.saveButton.isEnabled = true
        
        for result in results {
            result.itemProvider.loadObject(
                ofClass: UIImage.self,
                completionHandler: { (object, error) in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async { [weak self] in
                            let beginImage = CIImage(image: image)
                            self?.currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
                            self?.applyProcessing()
                            self?.setAlertController()
                        }
                    }
                })
        }
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension MainViewController: UINavigationControllerDelegate,
                              UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        picker.dismiss(animated: true)
        currentImage = image
    }
}
