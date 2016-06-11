//
//  RecentsTableViewController.swift
//  Smashtag
//
//  Created by Kevin Pfefferle on 6/11/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import UIKit

class RecentsTableViewController: UITableViewController {

    // MARK: Model

    var recentSearches: [String] {
        return RecentSearches.list
    }

    // MARK: View

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.RecentCellIdentifier, forIndexPath: indexPath)

        cell.textLabel?.text = recentSearches[indexPath.row]

        return cell
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.TweetsSegueIdentifier {
            if let ttvc = segue.destinationViewController as? TweetTableViewController,
              let indexPath = tableView.indexPathForSelectedRow {
                ttvc.searchText = recentSearches[indexPath.row]
            }
        }
    }


    private struct Storyboard {
        private static let RecentCellIdentifier = "Recent Cell"
        private static let TweetsSegueIdentifier = "Show Tweets from Recent"
    }

}
