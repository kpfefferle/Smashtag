//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Kevin Pfefferle on 6/9/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet private weak var tweetScreenNameLabel: UILabel!
    @IBOutlet private weak var tweetTextLabel: UILabel!
    @IBOutlet private weak var tweetProfileImageView: UIImageView!
    @IBOutlet private weak var tweetCreatedLabel: UILabel!

    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }

    private let hightlights = [
        "hashtags": UIColor.red(),
        "urls": UIColor.blue(),
        "userMentions": UIColor.purple()
    ]

    private func updateUI() {

        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil

        // load new information from out tweet (if any)
        if let tweet = self.tweet {

            let attributedTweetText = NSMutableAttributedString(string: tweet.text)
            for (key, color) in hightlights {
                for mention in tweet.value(forKey: key) as! [Twitter.Mention] {
                    attributedTweetText.addAttribute(NSForegroundColorAttributeName, value: color, range: mention.nsrange)
                }
            }
            for _ in tweet.media {
                attributedTweetText.append(AttributedString(string: " 📷"))
            }
            tweetTextLabel?.attributedText = attributedTweetText

            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description

            if let profileImageURL = tweet.user.profileImageURL {
                DispatchQueue.global(attributes: .qosUserInitiated).async { [ weak weakSelf = self ] in
                    let contentsOfURL = try? Data(contentsOf: profileImageURL)
                    DispatchQueue.main.async {
                        if let imageData = contentsOfURL
                          where profileImageURL == weakSelf?.tweet?.user.profileImageURL {
                            weakSelf?.tweetProfileImageView?.image = UIImage(data: imageData)
                        }
                    }
                }
            }

            let formatter = DateFormatter()
            if Date().timeIntervalSince(tweet.created) > 24*60*60 {
                formatter.dateStyle = DateFormatter.Style.shortStyle
            } else {
                formatter.timeStyle = DateFormatter.Style.shortStyle
            }
            tweetCreatedLabel?.text = formatter.string(from: tweet.created)
        }
    }

}
