//
//  PhotoPageController.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 3/14/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//

import UIKit

class PhotoPageController: UIPageViewController {

    var photos: [Photo] = []
    var indexOfCurrentPhoto: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let photoViewerController = photoViewerController(with: photos[indexOfCurrentPhoto]) {
            setViewControllers([photoViewerController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func photoViewerController(with photo: Photo) -> PhotoViewerController? {
        guard let storyboard = storyboard, let photoViewerController = storyboard.instantiateViewController(withIdentifier: "PhotoViewerController") as? PhotoViewerController else { return nil}
        photoViewerController.photo = photo
        return photoViewerController
    }
    
}

extension PhotoPageController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let photoVrC = viewController as? PhotoViewerController, let index = photos.index(of: photoVrC.photo) else { return nil }
        if index == photos.startIndex {
            return nil // No Controller available
        } else {
            let indexBefore = photos.index(before: index)
            let photo = photos[indexBefore]
            return photoViewerController(with: photo)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let photoVrC = viewController as? PhotoViewerController, let index = photos.index(of: photoVrC.photo) else { return nil }
        if index == photos.index(before: photos.endIndex) {
            return nil
        } else {
            let indexAfter = photos.index(after: index)
            let photo = photos[indexAfter]
            return photoViewerController(with: photo)
        }
    }
}
