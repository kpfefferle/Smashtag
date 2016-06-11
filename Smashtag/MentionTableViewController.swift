//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Kevin Pfefferle on 6/10/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import UIKit
import Twitter

class MentionTableViewController: UITableViewController {

    // MARK: Model

    private var mentions = [Array<AnyObject>]() {
        didSet {
            tableView.reloadData()
        }
    }

    private let sectionTypes = [
        (key: "media", title: "Images", cell: Storyboard.MediaCellIdentifier),
        (key: "hashtags", title: "Hashtags", cell: Storyboard.MentionCellIdentifier),
        (key: "userMentions", title: "Users", cell: Storyboard.MentionCellIdentifier),
        (key: "urls", title: "URLs", cell: Storyboard.MentionCellIdentifier)
    ]

    var tweet: Twitter.Tweet? {
        didSet {
            mentions.removeAll()
            for (key,_,_) in sectionTypes {
                if let mentionArray = tweet?.valueForKey(key) as? [AnyObject] {
                    mentions.append(mentionArray)
                }
            }
            if let userScreenName = tweet?.user.screenName {
                title = "@\(userScreenName)"
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if mentions[section].count > 0 {
            return sectionTypes[section].title
        } else {
            return nil
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sectionTypes[indexPath.section].cell, forIndexPath: indexPath)

        let mention = mentions[indexPath.section][indexPath.row]

        if let mediaItem = mention as? Twitter.MediaItem {
            if let cell = cell as? MediaTableViewCell {
                cell.mediaItem = mediaItem
            }
        } else if let mention = mention as? Twitter.Mention {
            cell.textLabel?.text = mention.keyword
        }

        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mention = mentions[indexPath.section][indexPath.row]

        if let mediaItem = mention as? Twitter.MediaItem {
            return tableView.frame.width / CGFloat(mediaItem.aspectRatio)
        } else {
            return tableView.rowHeight
        }
    }

    // MARK: - Navigation

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 3:
            break
        default:
            performSegueWithIdentifier(Storyboard.TweetsSegueIdentifier, sender: self)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tweetVC = segue.destinationViewController as? TweetTableViewController,
          let indexPath = tableView.indexPathForSelectedRow,
          let mention = mentions[indexPath.section][indexPath.row] as? Twitter.Mention
          where segue.identifier == Storyboard.TweetsSegueIdentifier {
            tweetVC.searchText = mention.keyword
        }
    }

    private struct Storyboard {
        static let MediaCellIdentifier = "Media Cell"
        static let MentionCellIdentifier = "Mention Cell"
        static let TweetsSegueIdentifier = "Show Tweets"
    }
}
