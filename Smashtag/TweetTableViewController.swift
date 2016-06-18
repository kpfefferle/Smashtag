//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Kevin Pfefferle on 6/9/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    // MARK: Model

    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }

    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            title = searchText
            if let searchText = searchText {
                RecentSearches.add(searchText)
            }
        }
    }

    private var twitterRequest: Twitter.Request? {
        if let query = searchText where !query.isEmpty {
            return Twitter.Request(search: query + " -filter:retweets", count: 100)
        }
        return nil
    }

    private var lastTwitterRequest: Twitter.Request?

    private func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            UIApplication.shared().isNetworkActivityIndicatorVisible = true
            request.fetchTweets { [ weak weakSelf = self ] newTweets in
                DispatchQueue.main.async {
                    UIApplication.shared().isNetworkActivityIndicatorVisible = false
                    if request == weakSelf?.lastTwitterRequest &&
                      !newTweets.isEmpty {
                        weakSelf?.tweets.insert(newTweets, at: 0)
                    }
                }
            }
        }
    }

    @objc private func handleRefresh(_ sender: AnyObject?) {
        if let request = lastTwitterRequest?.requestForNewer {
            lastTwitterRequest = request
            request.fetchTweets { [ weak weakSelf = self ] newTweets in
                DispatchQueue.main.async {
                    if request == weakSelf?.lastTwitterRequest &&
                        !newTweets.isEmpty {
                        weakSelf?.tweets.insert(newTweets, at: 0)
                    }
                    weakSelf?.refreshControl?.endRefreshing()
               }
            }
        } else {
            refreshControl?.endRefreshing()
        }
    }

    // MARK: View

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(TweetTableViewController.handleRefresh(_:)), for: .valueChanged)
        refreshControl = refresher
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)

        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }

        return cell
    }

    @IBOutlet private weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? MentionTableViewController,
          let indexPath = tableView.indexPathForSelectedRow
          where segue.identifier == Storyboard.ShowMentionsSegue {
            destinationVC.tweet = tweets[indexPath.section][indexPath.row]
        }
    }

    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
        static let ShowMentionsSegue = "Show Mentions"
    }

}
