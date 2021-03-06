//
//  PhotoPickerManager.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 3/5/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//
import UIKit
import MobileCoreServices

protocol PhotoPickerManagerDelegate: AnyObject { // Could also be "class"
    func manager(_ manager: PhotoPickerManager, didPickImage image: UIImage)
}

/// Has three instances: imgPickerC, presentingC, delegate.
class PhotoPickerManager: NSObject {
    private let imagePickerController = UIImagePickerController()
    private let presentingController: UIViewController
    weak var delegate: PhotoPickerManagerDelegate?
    
    init(presentingViewController: UIViewController) {
        self.presentingController = presentingViewController
        super.init() // NSObject has some things to init.
        
        configure()
    }
    
    func presentPhotoPicker(animated: Bool) {
        presentingController.present(imagePickerController, animated: animated, completion: nil) // "presentingController" presents a view controller  which is imagePickerController modally.
    }
    
    func dismissPhotoPicker(animated: Bool, comletion:(() -> Void)?) {
        imagePickerController.dismiss(animated: animated, completion: comletion)
    }

    private func configure() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) { // 如果可以用camera
            imagePickerController.sourceType = .camera
            imagePickerController.cameraDevice = .rear
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        // k: Constant Objetive-C Convention
        // UT: Uniform Type
        imagePickerController.mediaTypes = [kUTTypeImage as String] // 好像这句可有可无
        imagePickerController.delegate = self
    }
}

extension PhotoPickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        delegate?.manager(self, didPickImage: image)
    }
}
