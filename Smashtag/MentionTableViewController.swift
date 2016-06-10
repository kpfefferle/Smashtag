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

    // MARK: View

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
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
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.DemoCellIdentifier, forIndexPath: indexPath)

        let mention = mentions[indexPath.section][indexPath.row]
        if let mediaItem = mention as? Twitter.MediaItem {
            cell.textLabel?.text = String(mediaItem.url)
        } else if let mention = mention as? Twitter.Mention {
            cell.textLabel?.text = mention.keyword
        }

        return cell
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
        static let DemoCellIdentifier = "Mention"
    }
}
