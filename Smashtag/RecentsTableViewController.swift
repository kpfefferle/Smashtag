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

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.RecentCellIdentifier, for: indexPath)

        cell.textLabel?.text = recentSearches[indexPath.row]

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.TweetsSegueIdentifier {
            if let ttvc = segue.destinationViewController as? TweetTableViewController,
              let indexPath = tableView.indexPathForSelectedRow {
                ttvc.searchText = recentSearches[indexPath.row]
            }
        } else if segue.identifier == Storyboard.PopularSegueIdentifier {
            if let popularTVC = segue.destinationViewController as? PopularTableViewController,
              let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) {
                popularTVC.title = recentSearches[indexPath.row]
            }
        }
    }

    private struct Storyboard {
        private static let RecentCellIdentifier = "Recent Cell"
        private static let TweetsSegueIdentifier = "Show Tweets from Recent"
        private static let PopularSegueIdentifier = "Recent to Popular"
    }

}
