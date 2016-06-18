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

    @IBOutlet private weak var mediaImage: UIImageView!

    var mediaItem: Twitter.MediaItem? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        mediaImage?.image = nil

        if let mediaImageURL = mediaItem?.url {
            DispatchQueue.global(attributes: .qosUserInitiated).async { [ weak weakSelf = self ] in
                let contentsOfURL = try? Data(contentsOf: mediaImageURL)
                DispatchQueue.main.async {
                    if let imageData = contentsOfURL
                      where mediaImageURL == weakSelf?.mediaItem?.url {
                        weakSelf?.mediaImage?.image = UIImage(data: imageData)
                        weakSelf?.mediaImage.sizeToFit()
                    }
                }
            }
        }
    }
}
