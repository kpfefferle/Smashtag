//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Kevin Pfefferle on 6/10/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import UIKit
import Twitter

class MediaTableViewCell: UITableViewCell {

    @IBOutlet weak var mediaImage: UIImageView!

    var mediaItem: Twitter.MediaItem? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        mediaImage?.image = nil

        if let mediaImageURL = mediaItem?.url {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [ weak weakSelf = self ] in
                let contentsOfURL = NSData(contentsOfURL: mediaImageURL)
                dispatch_async(dispatch_get_main_queue()) {
                    if let imageData = contentsOfURL
                      where mediaImageURL == weakSelf?.mediaItem?.url {
                        weakSelf?.mediaImage?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
