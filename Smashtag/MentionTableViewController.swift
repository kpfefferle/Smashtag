//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Kevin Pfefferle on 6/10/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import UIKit
import SafariServices
import Twitter

class MentionTableViewController: UITableViewController {

    // MARK: Model

    private var mentions = [Array<AnyObject>]() {
        didSet {
            tableView.reloadData()
        }
    }

    private func mentionForIndexPath(_ indexPath: IndexPath) -> AnyObject? {
        return mentions[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
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
                if let mentionArray = tweet?.value(forKey: key) as? [AnyObject] {
                    mentions.append(mentionArray)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if mentions[section].count > 0 {
            return sectionTypes[section].title
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sectionTypes[indexPath.section].cell, for: indexPath)

        let mention = mentionForIndexPath(indexPath)

        if let mediaItem = mention as? Twitter.MediaItem {
            if let cell = cell as? MediaTableViewCell {
                cell.mediaItem = mediaItem
            }
        } else if let mention = mention as? Twitter.Mention {
            cell.textLabel?.text = mention.keyword
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let mediaItem = mentionForIndexPath(indexPath) as? Twitter.MediaItem {
            return tableView.frame.width / CGFloat(mediaItem.aspectRatio)
        } else {
            return UITableViewAutomaticDimension
        }
    }

    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sectionTypes[indexPath.section].key {
        case "media":
            performSegue(withIdentifier: Storyboard.ImageSegueIdentifier, sender: self)
        case "urls":
            if let mention = mentionForIndexPath(indexPath),
              let url = URL(string: mention.keyword) {
                openURLWithSafariVC(url)
            }
        default:
            performSegue(withIdentifier: Storyboard.TweetsSegueIdentifier, sender: self)
        }
    }

    private func openURLWithSafariVC(_ url: URL) {
        let svc = SFSafariViewController(url: url)
        self.present(svc, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if let imageVC = segue.destinationViewController as? ImageViewController,
          let indexPath = tableView.indexPathForSelectedRow,
          let mediaItem = mentionForIndexPath(indexPath) as? Twitter.MediaItem
          where segue.identifier == Storyboard.ImageSegueIdentifier {
            imageVC.imageURL = mediaItem.url
        } else if let tweetVC = segue.destinationViewController as? TweetTableViewController,
          let indexPath = tableView.indexPathForSelectedRow,
          let mention = mentionForIndexPath(indexPath) as? Twitter.Mention
          where segue.identifier == Storyboard.TweetsSegueIdentifier {
            tweetVC.searchText = mention.keyword
        }
    }

    private struct Storyboard {
        static let MediaCellIdentifier = "Media Cell"
        static let MentionCellIdentifier = "Mention Cell"
        static let TweetsSegueIdentifier = "Show Tweets"
        static let ImageSegueIdentifier = "Show Image"
    }
}
