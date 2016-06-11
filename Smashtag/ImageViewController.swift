//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Kevin Pfefferle on 6/10/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    var imageURL: NSURL? {
        didSet {
            image = nil
            fetchImage()
        }
    }

    private func fetchImage() {
        if let url = imageURL {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [ weak weakSelf = self ] in
                if let imageData = NSData(contentsOfURL: url) {
                    dispatch_async(dispatch_get_main_queue()) {
                        weakSelf?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }

    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            zoomToImage()
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.25
            scrollView.maximumZoomScale = 2.0
        }
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    private var imageView = UIImageView()

    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            zoomToImage()
        }
    }

    private func zoomToImage() {
        scrollView?.contentSize = imageView.frame.size
        scrollView?.zoomToRect(imageView.frame, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }

}
