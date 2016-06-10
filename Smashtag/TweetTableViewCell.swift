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

    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!

    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }

    private let hightlights = [
        "hashtags": UIColor.redColor(),
        "urls": UIColor.blueColor(),
        "userMentions": UIColor.purpleColor()
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
                for mention in tweet.valueForKey(key) as! [Twitter.Mention] {
                    attributedTweetText.addAttribute(NSForegroundColorAttributeName, value: color, range: mention.nsrange)
                }
            }
            for _ in tweet.media {
                attributedTweetText.appendAttributedString(NSAttributedString(string: " 📷"))
            }
            tweetTextLabel?.attributedText = attributedTweetText

            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description

            if let profileImageURL = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [ weak weakSelf = self ] in
                    let contentsOfURL = NSData(contentsOfURL: profileImageURL)
                    dispatch_async(dispatch_get_main_queue()) {
                        if let imageData = contentsOfURL
                          where profileImageURL == weakSelf?.tweet?.user.profileImageURL {
                            weakSelf?.tweetProfileImageView?.image = UIImage(data: imageData)
                        }
                    }
                }
            }

            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
    }

}
