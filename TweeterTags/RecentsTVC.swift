//
//  RecentsTVC.swift
//  TweeterTags
//
//  Created by Harvey on 23/11/2022.
//

import UIKit

class RecentsTVC: UITableViewController {
    
    var searchHistory = [String]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if let searchHistory = UserDefaults.standard.object(forKey: "tweeterTags.searchHistory") as? [String] {
            self.searchHistory = searchHistory
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self 
        tableView.dataSource = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 45 }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        switch StoryboardIdentifiers(segue)! {
        case .historySegue:
            if let tweetsTVC = destinationVC as? TweetsTVC {
                let indexPath = tableView.indexPathForSelectedRow!
                if let cell = tableView.cellForRow(at: indexPath) {
                    if let cellText = cell.textLabel?.text {
                            tweetsTVC.twitterQueryText = cellText
                    }
                }
            }
        // Never reached due to shouldPerformSegue conditions
        default:
            break
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch StoryboardIdentifiers(rawValue: identifier)! {
        case .historySegue:
            return true
        default:
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchHistory", for: indexPath)
        let search = searchHistory[indexPath.row]
        cell.textLabel?.text = search
        return cell
    }
    
}
