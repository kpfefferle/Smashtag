//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Kevin Pfefferle on 6/10/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    var imageURL: URL? {
        didSet {
            image = nil
            fetchImage()
        }
    }

    private func fetchImage() {
        if let url = imageURL {
            DispatchQueue.global(attributes: .qosUserInitiated).async { [ weak weakSelf = self ] in
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
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

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
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
        scrollView?.zoom(to: imageView.frame, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }

}
