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

    var mentions = [Array<AnyObject>]() {
        didSet {
            tableView.reloadData()
        }
    }

    private let tweetSections = [
        "media",
        "hashtags",
        "userMentions",
        "urls"
    ]

    var tweet: Twitter.Tweet? {
        didSet {
            mentions.removeAll()
            for key in tweetSections {
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

    private let sectionTitles = [
        "Images",
        "Hashtags",
        "Users",
        "URLs"
    ]

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if mentions[section].count > 0 {
            return sectionTitles[section]
        } else {
            return nil
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!

        let mention = mentions[indexPath.section][indexPath.row]

        if let mediaItem = mention as? Twitter.MediaItem {
            cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MediaCellIdentifier, forIndexPath: indexPath)
            if let cell = cell as? MediaTableViewCell {
                cell.mediaItem = mediaItem
            }
        } else if let mention = mention as? Twitter.Mention {
            cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MentionCellIdentifier, forIndexPath: indexPath)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private struct Storyboard {
        static let MediaCellIdentifier = "Media Cell"
        static let MentionCellIdentifier = "Mention Cell"
    }
}
