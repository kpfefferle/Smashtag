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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private struct Storyboard {
        private static let RecentCellIdentifier = "Recent Cell"
    }

}
