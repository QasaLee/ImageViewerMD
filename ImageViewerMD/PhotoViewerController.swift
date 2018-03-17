//
//  PhotoViewerController.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 3/14/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//

import UIKit

class PhotoViewerController: UIViewController {
    
    var photo: Photo!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBAction func launchPhotoZoomController(_ sender: Any) {
        guard let storyboard = storyboard else { return }
        let zoomController = storyboard.instantiateViewController(withIdentifier: "PhotoZoomController") as! PhotoZoomController
        zoomController.photo = photo
        
        navigationController?.present(zoomController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() { // 因为继承过所以用override
        super.viewDidLoad()
        photoImageView.image = photo.image
    }
    
}
