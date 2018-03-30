//
//  PhotoMetadataController.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 3/29/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//

import UIKit

class PhotoMetadataController: UITableViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var captionTextField: UITextField!
    
    @IBOutlet weak var tagsTextFiled: UITextField!
    
    
    var displayPhoto: UIImage?
    var photo: UIImage?
    var filter: CIFilter?
    var tags = [String]()
    
    let queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        
        photoImageView.image = displayPhoto
        if let tagsText = tagsTextFiled.text {
            tags = tags(from: tagsText)
        }
        applyFilter(scaleFactor: 0.25)
    }
    
    
    func applyFilter(scaleFactor scale: CGFloat) {
        guard let image = photo, let selectedFilter = filter else { return }
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let size = CGSize(width: imageWidth * scale, height: imageHeight * scale)
        guard let resizedImage = image.resized(to: size) else { return }
        let filtrationImage = FiltrationImage(image: resizedImage)
        
        let operation = ImageFiltrationOperation(image: filtrationImage, filter: selectedFilter)
        operation.completionBlock = {
            if operation.isCancelled { return }
            self.photo = operation.filtrationImage.image
        }
        
        queue.addOperation(operation)
    }
    
    func setupNavigation() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(PhotoMetadataController.savePhoto))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func savePhoto() {
        
    }
    
}

extension PhotoMetadataController {
    func tags(from text: String) -> [String] {
        let commaSeperatedStrings = text.split(separator: ",").map { String.init($0) } //Creates a new string from the given substring.
//        let commaSeperatedStrings = text.split(separator: ",").map(String.init)
        let lowercasedTags = commaSeperatedStrings.map { $0.lowercased() }
        return lowercasedTags.map {
            $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
}



